# Mattslasher

[![Master](https://travis-ci.org/cheldt/mattslasher.svg?branch=master)](https://travis-ci.org/cheldt/mattslasher)
[![codecov](https://codecov.io/gh/cheldt/mattslasher/branch/master/graph/badge.svg?token=)](https://codecov.io/gh/cheldt/mattslasher)

Simple http server, which handles mattermost slash commands.

Supported slashcommands:

- /weather [cityname]

## Configuration

Mattslasher is configurable via environment variables:

### Mandatory

- MATTSLASHER_PORT
- OPENWEATHERMAP_API_KEY

### Optional

- OPENWEATHERMAP_API_LANG e.g. en
- OPENWEATHERMAP_API_UNIT e.g. [metric|imperial]
- OPENWEATHERMAP_API_TIMEZONE e.g. Europe/Berlin
- OPENWEATHERMAP_API_CACHE_TTL e.g. 60 (Sec)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mattslasher` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mattslasher, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/mattslasher](https://hexdocs.pm/mattslasher).
