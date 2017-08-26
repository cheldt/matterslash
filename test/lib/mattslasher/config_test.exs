defmodule Mattslasher.ConfigTest do 
  use ExUnit.Case, async: true
  import Mattslasher.Config

  test "get_system_env returns default value on missing variable" do
    assert "foo_default" === get_system_env("FOOOOOOO_BAAAAAAR", "foo_default")
  end

  test "get_system_env returns value on existing variable" do
    System.put_env("FOOOOO_BAAAAAAARR_TEST", "foo_bar_baz")

    assert "foo_bar_baz" === get_system_env("FOOOOO_BAAAAAAARR_TEST", "foo")
  end
end