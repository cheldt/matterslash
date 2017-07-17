# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
config :mattslasher,
    allowed_request_keys: [
        "response_url",
        "text",
        "token",
        "channel_id",
        "team_id",
        "command",
        "team_domain",
        "user_name",
        "channel_name"
    ],
    openweathermap_api_url: "http://api.openweathermap.org/data/2.5/",
    openweathermap_api_units: %{
        "temperatur" => %{ "standard" => "K", "metric" => "°C", "imperial" => "F" },
        "pressure" => %{ "standard" => "hPa" },
        "speed" => %{ "standard" => "meter/sec", "imperial" => "miles/hour" },
        "precipitation" => %{ "standard" => "mm"},
        "wind_direction" => %{ "standard" => "degree"},
        "cloudiness" => %{ "standard" => "%" },
        "humidity" => %{ "standard" => "%"}
    }
#
# And access this configuration in your application as:
#
#     Application.get_env(:mattslasher, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
