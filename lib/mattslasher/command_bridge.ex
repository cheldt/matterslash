defmodule Mattslasher.CommandBridge do

  def execute_weather_command(cityname) do
    current_weather_data = OpenWeatherMap.CurrentWeatherData.by_city_name_cached(cityname)
    
    if current_weather_data.cod !== 200 do
      current_weather_data.message
    else
      Mattslasher.MattermostTable.render_table(
        %Mattslasher.MattermostTable{
          alignments: ["c", "c"],
          rows:       OpenWeatherMap.CurrentWeatherData.map_struct_to_list(
            current_weather_data,
            [["Name", "Value"]]
          ),
        }
      )
    end
  end
end