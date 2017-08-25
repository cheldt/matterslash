defmodule OpenWeatherMap.CurrentWeatherData do

  @moduledoc """
  Module for requesting current weather date from openweathermap api
  """

  @http_client_implenetation Application.fetch_env!(:mattslasher, :openweathermap_api_http_client_implementation)

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
    cod:         200,
    message:     "",
  ]

  @type t :: %__MODULE__{
    name:        String.t,
    country:     String.t,
    description: String.t,
    humidity:    OpenWeatherMap.Unit.t,
    pressure:    OpenWeatherMap.Unit.t,
    temp:        OpenWeatherMap.Unit.t,
    temp_max:    OpenWeatherMap.Unit.t,
    temp_min:    OpenWeatherMap.Unit.t,
    sunrise:     DateTime.t,
    sunset:      DateTime.t,
    wind_speed:  OpenWeatherMap.Unit.t,
    wind_degree: OpenWeatherMap.Unit.t,
    cod:         integer,
    message:     String.t,
  }

  @api_end_point "/weather"

  @doc """
  Returns current weather by city and caches result.
  Subsequent calls are served from cache.

  """
  @spec by_city_name_cached(String.t) :: OpenWeatherMap.CurrentWeatherData.t
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
  @spec by_city_name(String.t) :: OpenWeatherMap.CurrentWeatherData.t
  def by_city_name(cityname) do
    body = @http_client_implenetation.send_request(@api_end_point, get_params(cityname))

    size = map_size(body)

    if size === 2 do
      %{"cod" => cod, "message" => message} = body
      %OpenWeatherMap.CurrentWeatherData{cod: cod, message: message}
    else
      map_response_to_struct(
        body,
        Application.get_env(:mattslasher, :openweathermap_api_unit, "standard"),
        Application.get_env(:mattslasher, :openweathermap_api_units, %{})
      )
    end
  end

  @doc """
  Returns raw response of current weather by city.

  """
  @spec by_city_name_raw(String.t) :: map()
  def by_city_name_raw(cityname) do
    @http_client_implenetation.send_request(@api_end_point, get_params(cityname))
  end

  @doc """
  Maps response to struct.

  """
  @spec map_response_to_struct(map(), String.t, String.t) :: OpenWeatherMap.CurrentWeatherData.t
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
      cod:         response_body["cod"],
    }
  end

  @doc """
  Maps weather data struct to list.

  """
  @spec map_struct_to_list(OpenWeatherMap.CurrentWeatherData.t, List.t) :: List.t
  def map_struct_to_list(current_weather_data_struct, list \\ []) do
    timezone = Timex.Timezone.get(Application.get_env(:mattslasher, :openweathermap_api_timezone), Timex.now)

    Enum.reduce(
      Map.keys(current_weather_data_struct)
      |> Enum.filter(
        fn x -> x != :__struct__ and x != :cod and x != :message end
      ),
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

  defp get_params(cityname) do
    [q: cityname]
  end
end
