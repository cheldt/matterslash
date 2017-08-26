defmodule OpenWeatherMap.HttpClient do
  use Maxwell.Builder, [:get]

  @moduledoc """
  Module for sending requests to openweathermap api

  """

  @maxwell_adapter_implentation Application.fetch_env!(:mattslasher, :maxwell_adapter_implementation)

  defmodule Behaviour do
    @callback send_request(String.t, List.t) :: map
  end

  middleware Maxwell.Middleware.BaseUrl, Application.get_env(:mattslasher, :openweathermap_api_url, "")
  middleware Maxwell.Middleware.Opts, connect_timeout: 3000
  middleware Maxwell.Middleware.DecodeJson

  adapter @maxwell_adapter_implentation

  @doc """
  Sends http request to api

  """
  @spec send_request(String.t, List.t) :: map
  def send_request(api_endpoint, parameters) do
    result = api_endpoint
    |> new()
    |> put_query_string(build_params(parameters))
    |> get()

    case result do
      {:ok, connection} ->
        connection.resp_body
      {:error, reason, _} ->
        %{"cod" => 500, "message" => reason}
    end
  end

  defp build_params(additional_params) do
    Enum.into(
      [
        APPID: Application.get_env(:mattslasher, :openweathermap_api_key, ""),
        lang:  Application.get_env(:mattslasher, :openweathermap_api_lang, ""),
        units: Application.get_env(:mattslasher, :openweathermap_api_unit, ""),
      ] ++ additional_params,
      %{}
    )
  end
end