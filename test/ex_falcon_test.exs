defmodule ExFalconTest do
  use ExUnit.Case
  doctest ExFalcon

  test "greets the world" do
    assert ExFalcon.hello() == :world
  end
end
