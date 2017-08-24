defmodule OpenWeatherMap.CachexMock do

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_data(data) do
    Agent.update(__MODULE__, fn _ -> data end)
  end

  def set(_, _, data, _) do
    Agent.update(__MODULE__, fn _ -> data end)
  end

  def get(_, _) do
    Agent.get(__MODULE__, fn data -> data end)
  end
end