defmodule OpenWeatherMap.CurrentWeatherDataTest do
  use ExUnit.Case, async: true
  import OpenWeatherMap.CurrentWeatherData

  test "map_response_to_struct maps response data to struct and converts values to elixir types" do
    response = %{
      "base" => "stations",
      "clouds" => %{"all" => 90},
      "cod" => 200,
      "coord" => %{"lat" => 49.79, "lon" => 9.94},
      "dt" => 1502446800,
      "id" => 2805615,
      "main" => %{"humidity" => 93, "pressure" => 1015, "temp" => 14.12, "temp_max" => 15, "temp_min" => 13},
      "name" => "Wuerzburg",
      "sys" => %{"country" => "DE", "id" => 4958, "message" => 0.4592, "sunrise" => 1502424322, "sunset" => 1502477058, "type" => 1},
      "visibility" => 9000,
      "weather" => [%{"description" => "Wolkenbedeckt", "icon" => "04d", "id" => 804, "main" => "Clouds"}],
      "wind" => %{"deg" => 240, "speed" => 4.1}
    }

    expected_struct = %OpenWeatherMap.CurrentWeatherData{
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
      wind_speed:  %OpenWeatherMap.Unit{symbol: "meter/sec", value: 4.1}
    }

    assert expected_struct === map_response_to_struct(response, "metric", Application.get_env(:mattslasher, :openweathermap_api_units, %{}))
  end

  test "map_struct_to_list maps weather data to list and converts types to human readable format" do
    struct = %OpenWeatherMap.CurrentWeatherData{
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
      wind_speed:  %OpenWeatherMap.Unit{symbol: "meter/sec", value: 4.1}
    }

    expected_list = [
      ["foo", "bar"],
      ["country", "DE"],
      ["description", "Wolkenbedeckt"],
      ["humidity", "93 %"],
      ["name", "Wuerzburg"],
      ["pressure", "1015 hPa"],
      ["sunrise", "06:05:22"],
      ["sunset", "20:44:18"],
      ["temp", "14.12 °C"],
      ["temp_max", "15 °C"],
      ["temp_min", "13 °C"],
      ["wind_degree", "240 degree"],
      ["wind_speed", "4.1 meter/sec"],
    ]

    assert expected_list === map_struct_to_list(struct, [["foo", "bar"]])
  end
end
