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

      conn
      |> send_resp(200, "Good")
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