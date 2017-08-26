defmodule Mattslasher.Plug.VerifyRequest do
  defmodule IncompleteRequestError do
    @moduledoc """
    Error raised when a required field is missing.
    """

    defexception message: "Missing parameters", plug_status: 400
  end

  def init(options), do: options

  def call(conn, opts) do
    if !Mattslasher.RequestParser.verify_request(conn.params, opts[:fields]) do
      raise IncompleteRequestError
    else
      conn
    end
  end
end