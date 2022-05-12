defmodule ExFalcon.Client.WS do
  @moduledoc """
  TODO:
  """
  @url "https://ws.falconx.io"
  @namespace "/streaming"
  @version "v2"

  def authenticate(_key, _secret, _passphrase) do
  end

  def subscribe(_event) do
    nil
  end
end
