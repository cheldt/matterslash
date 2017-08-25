use Mix.Config

config :mattslasher,
openweathermap_api_http_client_implementation: OpenWeatherMap.HttpClient,
cachex_implementation: Cachex
