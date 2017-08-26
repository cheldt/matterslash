defmodule OpenWeatherMap.HttpClientTest do
  use ExUnit.Case
  import OpenWeatherMap.HttpClient

  setup do
    MaxwellAdapterStub.start_link()
    :ok
  end

  test "send_request returns error on failed request" do
    conn = Maxwell.Conn.new("/")

    MaxwellAdapterStub.add_connection({:error, "fuu bar", conn})

    assert %{"cod" => 500, "message" => "fuu bar"} === send_request("xxx", [])
  end

  test "send_request returns response body on success" do
    conn = Maxwell.Conn.new("/")
    conn = %{conn| method: :get, state: :sent, status: 200, resp_headers: %{"content-type" => "application/json"}, resp_body: "{\"value\": 123}"}

    MaxwellAdapterStub.add_connection(conn)

    assert %{"value" => 123} === send_request("xxx", [])
  end
end