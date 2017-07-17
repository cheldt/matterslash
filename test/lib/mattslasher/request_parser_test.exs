defmodule Mattslasher.RequestParserTest do 
  use ExUnit.Case, async: true
  import Mattslasher.RequestParser

  test "verify_request returns false on empty params" do
    assert false === verify_request(%{}, [])
  end

  test "verify_request returns false on missing params" do
    assert false === verify_request(%{"foo" => "bar"}, ["bar"])
  end

  test "verify_request returns true, when all expected params are present" do
    assert true === verify_request(%{"foo" => "bar", "bar" => "foo"}, ["bar", "foo"])
  end

  test "parse_slashcommand returns empty Mattslasher.SlashCommand struct on empty params" do
    assert %Mattslasher.SlashCommand{
        channel_id:   "", 
        channel_name: "",
        command:      "", 
        response_url: "",
        team_domain:  "",
        team_id:      "",
        text:         "",
        token:        "",
        user_name:    ""
    } === parse_slashcommand(%{})
  end

  test "parse_slashcommand populates Mattslasher.SlashCommand with given post params" do
    assert %Mattslasher.SlashCommand{
        channel_id:   "", 
        channel_name: "bar",
        command:      "", 
        response_url: "foo",
        team_domain:  "",
        team_id:      "",
        text:         "",
        token:        "",
        user_name:    ""
    } === parse_slashcommand(%{"response_url" => "foo", "channel_name" => "bar"})
  end
end