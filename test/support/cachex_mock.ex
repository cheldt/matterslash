defmodule CachexMock do
  def start_link(_, _) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_data(data) do
    Agent.update(__MODULE__, fn _ -> data end)
  end

  def set(cache, key, data, _) do
    Agent.update(__MODULE__, fn _ -> {cache, key, data} end)
  end

  def get!(_, _) do
    Agent.get(__MODULE__, fn data -> data end)
  end
end