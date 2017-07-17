defmodule Mattslasher.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    
    put_runtime_config_to_app_config()

    port = String.to_integer(Application.get_env(:mattslasher, :cowboy_port, 4444))
    
    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Mattslasher.Worker.start_link(arg1, arg2, arg3)
      # worker(Mattslasher.Worker, [arg1, arg2, arg3]),
      worker(Mattslasher.Router, [port])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mattslasher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp put_runtime_config_to_app_config do
    Application.put_env(:mattslasher, :cowboy_port, System.get_env("MATTSLASHER_PORT"))
    Application.put_env(:mattslasher, :openweathermap_api_key, System.get_env("OPENWEATHERMAP_API_KEY"))
    Application.put_env(:mattslasher, :openweathermap_api_lang, System.get_env("OPENWEATHERMAP_API_LANG"))
    Application.put_env(:mattslasher, :openweathermap_api_unit, System.get_env("OPENWEATHERMAP_API_UNIT"))
  end
end
