defmodule Mattslasher.Config do
  @moduledoc """
  Module for managing runtime config
  """

  @doc """
  Popuplates application enironment with system environment variables

  """
  def put_runtime_config_to_app_config do
    Application.put_env(:mattslasher, :cowboy_port, String.to_integer(get_system_env("MATTSLASHER_PORT", "4444")))
    Application.put_env(:mattslasher, :openweathermap_api_key, get_system_env("OPENWEATHERMAP_API_KEY", ""))
    Application.put_env(:mattslasher, :openweathermap_api_lang, get_system_env("OPENWEATHERMAP_API_LANG", "de"))
    Application.put_env(:mattslasher, :openweathermap_api_unit, get_system_env("OPENWEATHERMAP_API_UNIT", "metric"))
    Application.put_env(:mattslasher, :openweathermap_api_timezone, get_system_env("OPENWEATHERMAP_API_TIMEZONE", "Europe/Berlin"))
    Application.put_env(:mattslasher, :openweathermap_api_cache_ttl, String.to_integer(get_system_env("OPENWEATHERMAP_API_CACHE_TTL", "30")))
  end

  @doc """
  Popuplates application enironment with system environment variables

  """
  @spec get_system_env(String.t, String.t) :: String.t
  def get_system_env(name, default) do
    value = System.get_env(name)
    if value === nil do
      default
    else
      value
    end
  end
end