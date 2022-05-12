defmodule ExFalconTest do
  use ExUnit.Case
  doctest ExFalcon

  test "inspect" do
    assert ExFalcon.get_trading_pairs() == :get
  end
end
