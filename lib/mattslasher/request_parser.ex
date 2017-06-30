defmodule Mattslasher.RequestParser do
  @moduledoc """
  Module for parsing mattermost slash-command requests
  """
  @doc """
  Verifies that all expected form vars are present in request.

  ## Examples
        
    iex> verify_request %{"foo" => "bar"}, ["bar"]
    false
    iex> verify_request %{"foo" => "bar", "bar" => "foo"}, ["bar", "foo"]
    true

  """
  def verify_request(params, expected_fields) do
    Enum.all?(
      expected_fields,
      fn(field) -> Enum.member?(Map.keys(params), field) end
    )
  end

  @doc """
  Assigns post params to slash command struct

  ## Examples

    iex> parse_slashcommand %{ 
    ...> "response_url" => "a",
    ...> "channel_name" => "i"
    ...> }
    %Mattslasher.SlashCommand{
      channel_id: "", 
      channel_name: "i",
      command: "", 
      response_url: "a",
      team_domain: "",
      team_id: "",
      text: "",
      token: "",
      user_name: ""
    }
    iex> parse_slashcommand %{ 
    ...> "response_url" => "a",
    ...> "text" => "b", 
    ...> "token" => "c",
    ...> "channel_id" => "d",
    ...> "team_id" => "e",
    ...> "command" => "f",
    ...> "team_domain" => "g",
    ...> "user_name" => "h",
    ...> "channel_name" => "i"
    ...> }
    %Mattslasher.SlashCommand{
      channel_id: "d", 
      channel_name: "i",
      command: "f", 
      response_url: "a",
      team_domain: "g",
      team_id: "e",
      text: "b",
      token: "c",
      user_name: "h"
    }

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
