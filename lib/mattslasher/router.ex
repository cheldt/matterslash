defmodule Mattslasher.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch
  
  post "/" do
    params = conn.params

    verified = Mattslasher.RequestParser.verify_request(
      params,
      Application.get_env(:mattslasher, :allowed_request_keys, [])
    )

    if verified == true do
      data = Mattslasher.RequestParser.parse_slashcommand(params)

      response =
        if data.command === "/weather" do
          current_weather_data = OpenWeatherMap.CurrentWeatherData.by_city_name_cached(data.text)

          Mattslasher.MattermostTable.render_table(
            %Mattslasher.MattermostTable{
              alignments: ["c", "c"],
              rows:       OpenWeatherMap.CurrentWeatherData.map_struct_to_list(
                current_weather_data,
                [["Name", "Value"]]
              ),
            }
          )
        else
          "good"
        end

      conn
      |> put_resp_header("Content-Type", "text/plain") |> send_resp(200, response)
    else
      conn 
      |> send_resp(400, "Bad Request!")
    end
  end

  get "/" do
    conn
    |> send_resp(200, "Nothing to see here.")
  end

  match _, do: send_resp(conn, 200, "Nothing to see here.")

  def start_link (port) do
    Plug.Adapters.Cowboy.http(Mattslasher.Router, [], port: port)
  end
end