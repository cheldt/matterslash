use Mix.Config

config :mattslasher,
openweathermap_api_http_client_implementation: OpenWeatherMap.HttpClientMock,
cachex_implementation: CachexMock
  