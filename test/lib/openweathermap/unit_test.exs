defmodule OpenWeatherMap.UnitTest do
  use ExUnit.Case, async: true
  import OpenWeatherMap.Unit

  test "to_unit returns undefined unit on unconfigured type and system of measurement" do
    assert %OpenWeatherMap.Unit{value: 3.0, symbol: "undef"}
     === to_unit(
      3.0,
      "foo",
      "bar",
      %{
        "temperatur" => %{"standard" => "K", "metric" => "°C", "imperial" => "F"},
      }
      )
  end

  test "to_unit returns standard unit on unconfigured system of measurement" do
    assert %OpenWeatherMap.Unit{value: 2.0, symbol: "K"}
     === to_unit(
      2.0,
      "temperatur",
      "metric",
      %{
        "temperatur" => %{"standard" => "K",},
      }
      )
  end
    
  test "to_unit returns unit on configured type and system of measurement" do
    assert %OpenWeatherMap.Unit{value: 2.0, symbol: "°C"}
     === to_unit(
      2.0,
      "temperatur",
      "metric",
      %{
        "temperatur" => %{"standard" => "K", "metric" => "°C", "imperial" => "F"},
      }
      )
  end

  test "to_string returns human readable representation" do
    assert "20.01 °C" === OpenWeatherMap.Unit.to_string(%OpenWeatherMap.Unit{value: 20.012, symbol: "°C"})
    assert "20.0-K" === OpenWeatherMap.Unit.to_string(%OpenWeatherMap.Unit{value: 20.012, symbol: "K"}, "-", 1)
  end
end