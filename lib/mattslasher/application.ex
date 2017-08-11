defmodule Mattslasher.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    put_runtime_config_to_app_config()

    port = Application.get_env(:mattslasher, :cowboy_port)
    
    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Mattslasher.Worker.start_link(arg1, arg2, arg3)
      # worker(Mattslasher.Worker, [arg1, arg2, arg3]),
      worker(Mattslasher.Router, [port]),
      worker(OpenWeatherMap.WeatherDataCache, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mattslasher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp put_runtime_config_to_app_config do
    Application.put_env(:mattslasher, :cowboy_port, String.to_integer(get_system_env("MATTSLASHER_PORT", "4444")))
    Application.put_env(:mattslasher, :openweathermap_api_key, get_system_env("OPENWEATHERMAP_API_KEY", ""))
    Application.put_env(:mattslasher, :openweathermap_api_lang, get_system_env("OPENWEATHERMAP_API_LANG", "de"))
    Application.put_env(:mattslasher, :openweathermap_api_unit, get_system_env("OPENWEATHERMAP_API_UNIT", "metric"))
    Application.put_env(:mattslasher, :openweathermap_api_timezone, get_system_env("OPENWEATHERMAP_API_TIMEZONE", "Europe/Berlin"))
    Application.put_env(:mattslasher, :openweathermap_api_cache_ttl, String.to_integer(get_system_env("OPENWEATHERMAP_API_CACHE_TTL", "30")))
  end

  defp get_system_env(name, default) do
    value = System.get_env(name)
    if value === nil do
      default
    else
      value
    end
  end
end
