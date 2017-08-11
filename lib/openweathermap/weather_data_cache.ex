defmodule OpenWeatherMap.WeatherDataCache do
  @moduledoc """
  Module for caching current weather data
  """

  @current_weather_data_cache_key "current_weather_data"

  @doc """
  Gets current weather from cache.
  Returns empty struct on empty cache.

  """
  @spec get_current_weather_data(String.t) :: OpenWeatherMap.Unit.t
  def get_current_weather_data(cityname) do
    data = Cachex.get!(
      :weather_data_cache,
      get_cache_key(cityname)
    )

    if data === nil do
      %OpenWeatherMap.CurrentWeatherData{}
    else
      data
    end
  end

  @doc """
  Writes current weather to cache.

  """
  @spec set_current_weather_data(OpenWeatherMap.Unit.t, String.t) :: {Cachex.status, true | false}
  def set_current_weather_data(data, cityname) do
    Cachex.set(
      :weather_data_cache,
      get_cache_key(cityname),
      data,
      get_options()
    )
  end  
  
  def start_link do
    Cachex.start_link(:weather_data_cache, [])
  end

  defp get_options do
    [ttl: :timer.seconds(Application.get_env(:mattslasher, :openweathermap_api_cache_ttl))]
  end

  defp get_cache_key(cityname) do
    String.downcase(cityname) <> @current_weather_data_cache_key
  end
end