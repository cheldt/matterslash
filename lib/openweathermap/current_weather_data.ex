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

  def by_city_name(cityname) do
    response = get(
      @api_end_point,
      query: build_params(
        [q: cityname],
        Application.get_env(:mattslasher, :openweathermap_api_key, ""),
        Application.get_env(:mattslasher, :openweathermap_api_lang, ""),
        Application.get_env(:mattslasher, :openweathermap_api_unit, "")
      )
    )

    map_to_struct(
      response.body,
      Application.get_env(:mattslasher, :openweathermap_api_unit, "standard"),
      Application.get_env(:mattslasher, :openweathermap_api_units, %{})
    )
  end

  defp map_to_struct(response_body, system_of_measurement, units_config) do
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

  defp build_params(api_key, lang, units, additional_params) do
    [
      APPID: api_key,
      lang:  lang,
      units: units,
    ] ++ additional_params
  end
end
