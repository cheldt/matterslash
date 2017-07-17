defmodule OpenWeatherMap.Unit do
  defstruct [
    value:  0.0,
    symbol: "undef",
  ]

  @doc """
  Returns OpenWeatherMap.Unit struct on matching types

  """
  def to_unit(value, type, system_of_measurement, units_config) do
    %OpenWeatherMap.Unit{
      value:  value,
      symbol: get_unit_from_config(type, system_of_measurement, units_config)
    }
  end
  
  @doc """
  Returns unit in human readable form

  """
  def to_string(unit, separator \\ " ", precision \\ 2) do
    Float.to_string(Float.round(unit.value, precision)) <> separator <> unit.symbol
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