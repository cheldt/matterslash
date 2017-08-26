defmodule Mattslasher.Router do
  use Plug.Router
  import Mattslasher.CommandBridge

  plug Plug.Parsers, parsers: [:urlencoded]
  plug Mattslasher.Plug.VerifyRequest, fields: Application.get_env(:mattslasher, :allowed_request_keys)
  plug :match
  plug :dispatch
  
  post "/" do
    params = conn.params

    data = Mattslasher.RequestParser.parse_slashcommand(params)

    response =
      if data.command === "/weather" do
        execute_weather_command(data.text)
      else
        "Unknown command."
      end

      conn
      |> put_resp_header("content-type", "text/plain") |> send_resp(200, response)
  end

  get "/" do
    conn
    |> send_resp(200, "Nothing to see here.")
  end

  def start_link (port) do
    Plug.Adapters.Cowboy.http(Mattslasher.Router, [], port: port)
  end
end