defmodule Mattslasher.RouterTest do 
  use ExUnit.Case
  use Plug.Test
  
  alias Mattslasher.Router

  @opts Router.init([])

  @content "response_url=foo&text=bar&token=baz&channel_id=bla&team_id=blub&command=blarg&team_domain=grab&user_name=xxx&channel_name=yyy"

  @response %{
    "base" => "stations",
    "clouds" => %{"all" => 90},
    "cod" => 200,
    "coord" => %{"lat" => 49.79, "lon" => 9.94},
    "dt" => 1502446800,
    "id" => 2805615,
    "main" => %{"humidity" => 93, "pressure" => 1015, "temp" => 14.12, "temp_max" => 15, "temp_min" => 13},
    "name" => "Wuerzburg",
    "sys" => %{"country" => "DE", "id" => 4958, "message" => 0.4592, "sunrise" => 1502424322, "sunset" => 1502477058, "type" => 1},
    "visibility" => 9000,
    "weather" => [%{"description" => "Wolkenbedeckt", "icon" => "04d", "id" => 804, "main" => "Clouds"}],
    "wind" => %{"deg" => 240, "speed" => 4.1}
  }

  test "returns 400 missing paraemters" do
    conn = conn(:post, "/", "")
  
    assert_raise Mattslasher.Plug.VerifyRequest.IncompleteRequestError, "Missing parameters", fn -> Router.call(conn, @opts) end

    assert conn.state == :unset
    assert conn.status == nil
  end

  test "returns unknown command on valid parameters but invalid command" do
    conn = conn(:post, "/", @content)
    |> put_req_header("content-type", "application/x-www-form-urlencoded")
    |> Router.call(@opts)
    
    assert conn.resp_body == "Unknown command."
    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns error from api call" do
    OpenWeatherMap.HttpClientStub.start_link()
    OpenWeatherMap.HttpClientStub.add_response(%{"cod" => 500, "message" => "api snafu"})
    OpenWeatherMap.WeatherDataCache.start_link()
    CachexStub.add_data(nil)

    conn = conn(:post, "/", String.replace(@content, "command=blarg", "command=/weather"))
    |> put_req_header("content-type", "application/x-www-form-urlencoded")
    |> Router.call(@opts)

    assert conn.resp_body == "api snafu"
    assert conn.state == :sent
    assert conn.status == 200
  end

  test "executes command on valid parameters and valid command" do
    OpenWeatherMap.HttpClientStub.start_link()
    OpenWeatherMap.HttpClientStub.add_response(@response)
    OpenWeatherMap.WeatherDataCache.start_link()
    CachexStub.add_data(nil)

    conn = conn(:post, "/", String.replace(@content, "command=blarg", "command=/weather"))
    |> put_req_header("content-type", "application/x-www-form-urlencoded")
    |> Router.call(@opts)
    
    assert conn.resp_body == "|Name|Value|\n|:-:|:-:|\n|country|DE|\n|description|Wolkenbedeckt|\n|humidity|93 %|\n|name|Wuerzburg|\n|pressure|1015 hPa|\n|sunrise|06:05:22|\n|sunset|20:44:18|\n|temp|14.12 °C|\n|temp_max|15 °C|\n|temp_min|13 °C|\n|wind_degree|240 degree|\n|wind_speed|4.1 meter/sec|\n"
    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns message on get request" do
    conn = conn(:get, "/?" <> @content, nil)
    |> Router.call(@opts)

    assert conn.resp_body == "Nothing to see here."
    assert conn.state == :sent
    assert conn.status == 200
  end
end