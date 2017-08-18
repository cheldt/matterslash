defmodule OpenWeatherMap.HttpClientMock do
  @behaviour OpenWeatherMap.HttpClient.Behaviour

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_response(response) do
    Agent.update(__MODULE__, fn _ -> response end)
  end  

  def clear do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  def send_request(_, _) do
    Agent.get(__MODULE__, fn response -> response end)
  end
end