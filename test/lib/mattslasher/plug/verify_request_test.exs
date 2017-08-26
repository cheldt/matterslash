defmodule Mattslasher.Plug.VerifyRequestTest do
  use ExUnit.Case, async: true
  import Mattslasher.Plug.VerifyRequest

  test "init returns options untouched" do
    assert [] === init([])
  end
end