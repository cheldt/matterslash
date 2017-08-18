defmodule OpenWeatherMap.HttpClient do
  use Tesla.Builder

  @moduledoc """
  Module for sending requests to openweathermap api

  """

  defmodule Behaviour do
    @callback send_request(String.t, List.t) :: map
  end

  plug Tesla.Middleware.BaseUrl, Application.get_env(:mattslasher, :openweathermap_api_url, "")
  plug Tesla.Middleware.JSON

  @doc """
  Sends http request to api

  """
  @spec send_request(String.t, List.t) :: map
  def send_request(api_endpoint, parameters) do
    try do
      response = get(
        api_endpoint,
        query: build_params(parameters)
      )

      response.body
    catch
       _, tesla_error -> %{"cod" => 500, "message" => tesla_error.message}
    end
  end

  defp build_params(additional_params) do
    [
      APPID: Application.get_env(:mattslasher, :openweathermap_api_key, ""),
      lang:  Application.get_env(:mattslasher, :openweathermap_api_lang, ""),
      units: Application.get_env(:mattslasher, :openweathermap_api_unit, ""),
    ] ++ additional_params
  end
end