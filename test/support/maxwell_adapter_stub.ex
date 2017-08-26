defmodule MaxwellAdapterStub do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_connection(conn) do
    Agent.update(__MODULE__, fn _ -> conn end)
  end  

  def call(_) do
    Agent.get(__MODULE__, fn conn -> conn end)
  end
end