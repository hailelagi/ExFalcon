defmodule ExFalcon.Behaviour do
  @moduledoc """
    Expected behaviour for the falcon library to implement
  """
  @callback hello(String.t()) :: atom()
end
