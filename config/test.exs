use Mix.Config

config :mattslasher,
openweathermap_api_http_client_implementation: OpenWeatherMap.HttpClientStub,
cachex_implementation: CachexStub,
maxwell_adapter_implementation: MaxwellAdapterStub
  