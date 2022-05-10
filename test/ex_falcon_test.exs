defmodule ExFalconTest do
  use ExUnit.Case
  doctest ExFalcon

  test "greets the world" do
    assert ExFalcon.hello() == "fail"
  end
end
