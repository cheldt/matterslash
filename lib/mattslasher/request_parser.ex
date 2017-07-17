defmodule Mattslasher.RequestParser do
  @moduledoc """
  Module for parsing mattermost slash-command requests
  """

  @doc """
  Verifies, that all expected form vars are present in request.

  """
  def verify_request(params, expected_fields) do
    if %{} == params do
      false
    else
      Enum.all?(
        expected_fields,
        fn(field) -> Enum.member?(Map.keys(params), field) end
      )
    end
  end

  @doc """
  Assigns post params to slash command struct

  """
  def parse_slashcommand(params) do
    struct(
        Mattslasher.SlashCommand,
        Enum.reduce(
          Map.keys(params),
          %{},
          fn(param, acc) ->
              Map.put(
                acc,
                String.to_atom(param),
                Map.get(params, param)
              ) 
          end
        )
    )
  end
end
