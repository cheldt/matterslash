defmodule OpenWeatherMap.WeatherDataCacheTest do
  use ExUnit.Case, async: true
  import OpenWeatherMap.WeatherDataCache
  
  setup do
    start_link()
    :ok
  end 

  test "get_current_weather_data returns empty struct on missing cached data" do
    CachexMock.add_data(nil);

    expected_result = %OpenWeatherMap.CurrentWeatherData{}

    assert expected_result === get_current_weather_data("fooo");
  end

  test "get_current_weather_data returns populated struct on cached data" do
    expected_result = %OpenWeatherMap.CurrentWeatherData{
      country:     "DE",
      description: "Wolkenbedeckt",
      humidity:    %OpenWeatherMap.Unit{symbol: "%", value: 93},
      name:        "Wuerzburg",
      pressure:    %OpenWeatherMap.Unit{symbol: "hPa", value: 1015},
      sunrise:     DateTime.from_unix!(1502424322),
      sunset:      DateTime.from_unix!(1502477058),
      temp:        %OpenWeatherMap.Unit{symbol: "°C", value: 14.12},
      temp_max:    %OpenWeatherMap.Unit{symbol: "°C", value: 15},
      temp_min:    %OpenWeatherMap.Unit{symbol: "°C", value: 13},
      wind_degree: %OpenWeatherMap.Unit{symbol: "degree", value: 240},
      wind_speed:  %OpenWeatherMap.Unit{symbol: "meter/sec", value: 4.1},
      cod:         200
    }

    CachexMock.add_data(expected_result);

    assert expected_result === get_current_weather_data("fooo");
  end

  test "set_current_weather_data returns cached data" do
    cached_data = %OpenWeatherMap.CurrentWeatherData{
      country:     "DE",
      description: "Wolkenbedeckt",
      humidity:    %OpenWeatherMap.Unit{symbol: "%", value: 93},
      name:        "Wuerzburg",
      pressure:    %OpenWeatherMap.Unit{symbol: "hPa", value: 1015},
      sunrise:     DateTime.from_unix!(1502424322),
      sunset:      DateTime.from_unix!(1502477058),
      temp:        %OpenWeatherMap.Unit{symbol: "°C", value: 14.12},
      temp_max:    %OpenWeatherMap.Unit{symbol: "°C", value: 15},
      temp_min:    %OpenWeatherMap.Unit{symbol: "°C", value: 13},
      wind_degree: %OpenWeatherMap.Unit{symbol: "degree", value: 240},
      wind_speed:  %OpenWeatherMap.Unit{symbol: "meter/sec", value: 4.1},
      cod:         200
    }

    set_current_weather_data(cached_data, "FOOBAR ")

    expected_result = {:weather_data_cache, "foobarcurrent_weather_data", cached_data}

    assert expected_result === get_current_weather_data("FOOBAR ")
  end

end