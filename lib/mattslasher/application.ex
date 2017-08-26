defmodule Mattslasher.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  import Mattslasher.Config

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
end
