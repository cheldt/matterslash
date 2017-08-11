defmodule OpenWeatherMap.CurrentWeatherData do
  use Tesla.Builder

  defstruct [
    name:        "",
    country:     "",
    description: "",
    humidity:    %OpenWeatherMap.Unit{},
    pressure:    %OpenWeatherMap.Unit{},
    temp:        %OpenWeatherMap.Unit{},
    temp_max:    %OpenWeatherMap.Unit{},
    temp_min:    %OpenWeatherMap.Unit{},
    sunrise:     DateTime.utc_now,
    sunset:      DateTime.utc_now,
    wind_speed:  %OpenWeatherMap.Unit{},
    wind_degree: %OpenWeatherMap.Unit{},
  ]

  @api_end_point "/weather"
  
  plug Tesla.Middleware.BaseUrl, Application.get_env(:mattslasher, :openweathermap_api_url, "")
  plug Tesla.Middleware.JSON

  @doc """
  Returns current weather by city and caches result.
  Subsequent calls are served from cache.

  """
  def by_city_name_cached(cityname) do
    cached_data = OpenWeatherMap.WeatherDataCache.get_current_weather_data(cityname)
    
    if %OpenWeatherMap.CurrentWeatherData{} == cached_data do
      weather_data = by_city_name(cityname)

      OpenWeatherMap.WeatherDataCache.set_current_weather_data(weather_data, cityname)

      weather_data
    else
      cached_data
    end
  end

  @doc """
  Returns current weather by city as struct.

  """
  def by_city_name(cityname) do
    response = get(
      @api_end_point,
      query: build_params([q: cityname])
    )

    if response.body === nil do
      %OpenWeatherMap.CurrentWeatherData{}
    else 
      map_response_to_struct(
        response.body,
        Application.get_env(:mattslasher, :openweathermap_api_unit, "standard"),
        Application.get_env(:mattslasher, :openweathermap_api_units, %{})
      )
    end
  end

  @doc """
  Returns raw response of current weather by city.

  """
  def by_city_name_raw(cityname) do
    response = get(
      @api_end_point,
      query: build_params([q: cityname])
    )
    if response.body === nil do
      ""
    else
      response.body
    end
  end

  @doc """
  Maps response to struct.

  """
  def map_response_to_struct(response_body, system_of_measurement, units_config) do
    %OpenWeatherMap.CurrentWeatherData{
      name:        response_body["name"],
      country:     response_body["sys"]["country"],
      description: Map.get(List.first(response_body["weather"]), "description", ""),
      humidity:    OpenWeatherMap.Unit.to_unit(response_body["main"]["humidity"], "humidity", system_of_measurement, units_config),
      pressure:    OpenWeatherMap.Unit.to_unit(response_body["main"]["pressure"], "pressure", system_of_measurement, units_config),
      temp:        OpenWeatherMap.Unit.to_unit(response_body["main"]["temp"], "temperatur", system_of_measurement, units_config),
      temp_max:    OpenWeatherMap.Unit.to_unit(response_body["main"]["temp_max"], "temperatur", system_of_measurement, units_config),
      temp_min:    OpenWeatherMap.Unit.to_unit(response_body["main"]["temp_min"], "temperatur", system_of_measurement, units_config),
      sunrise:     DateTime.from_unix!(response_body["sys"]["sunrise"]),
      sunset:      DateTime.from_unix!(response_body["sys"]["sunset"]),
      wind_speed:  OpenWeatherMap.Unit.to_unit(response_body["wind"]["speed"], "speed", system_of_measurement, units_config),
      wind_degree: OpenWeatherMap.Unit.to_unit(response_body["wind"]["deg"], "wind_direction", system_of_measurement, units_config),
    }
  end

  @doc """
  Maps weather data struct to list.

  """
  def map_struct_to_list(current_weather_data_struct, list \\ []) do
    timezone = Timex.Timezone.get(Application.get_env(:mattslasher, :openweathermap_api_timezone), Timex.now)

    Enum.reduce(
      Map.keys(current_weather_data_struct) |> Enum.filter(fn x -> x != :__struct__ end),
      list,
      fn(param, acc) ->
        value = Map.get(current_weather_data_struct, param)

        string_value =
          case value do
            %OpenWeatherMap.Unit{} ->
              OpenWeatherMap.Unit.to_string(value)
            %DateTime{} ->
              Time.to_string(Timex.Timezone.convert(value, timezone))
              _ ->
                value
          end

        acc ++ [[Atom.to_string(param), string_value]]
      end
    )
  end

  defp build_params(additional_params) do
    [
      APPID: Application.get_env(:mattslasher, :openweathermap_api_key, ""),
      lang:  Application.get_env(:mattslasher, :openweathermap_api_lang, ""),
      units: Application.get_env(:mattslasher, :openweathermap_api_unit, ""),
    ] ++ additional_params
  end
end
