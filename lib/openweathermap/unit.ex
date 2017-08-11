defmodule OpenWeatherMap.Unit do
  @moduledoc """
  Module for converting openweathermap values into units.
  """
  defstruct [
    value:  0.0,
    symbol: "undef",
  ]

  @type t :: %__MODULE__{
    value:  number,
    symbol: String.t,
  }

  @doc """
  Returns OpenWeatherMap.Unit struct on matching types

  """
  @spec to_unit(number, String.t, String.t, map) :: OpenWeatherMap.Unit.t
  def to_unit(value, type, system_of_measurement, units_config) do
    %OpenWeatherMap.Unit{
      value:  value,
      symbol: get_unit_from_config(type, system_of_measurement, units_config)
    }
  end
  
  @doc """
  Returns unit in human readable form

  """
  @spec to_string(OpenWeatherMap.Unit.t, String.t, integer) :: String.t
  def to_string(unit, separator \\ " ", precision \\ 2) do
    string_value =
      if is_integer(unit.value) do
          Integer.to_string(unit.value)
      else
          Float.to_string(Float.round(unit.value, precision))
      end

    string_value <> separator <> unit.symbol
  end

  defp get_unit_from_config(type, system_of_measurement, units_config) do
    unit = units_config[type][system_of_measurement]

    if unit === nil do
      Map.get(Map.get(units_config, type, %{}), "standard", "undef")
    else 
      unit
    end
  end
end