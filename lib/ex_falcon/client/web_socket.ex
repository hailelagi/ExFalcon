defmodule ExFalcon.Client.WS do
  @moduledoc """
    WebSocket client api for querying the FalconX API.
  """
  use WebSockex
  alias ExFalcon.Client.Sign

  @url "https://ws.falconx.io"
  @namespace "/streaming"
  @version "v2"

  def start_link(state) do
    # todo: namespace the ws client
    WebSockex.start_link(@url, __MODULE__, state)
  end

  def subscribe(_event) do
    nil
  end

  def handle_frame({:event, msg}, state) do
    {:ok, state}
  end

  def add_headers() do
    api_key = Application.get_env(:ex_falcon, :api_key)
    passphrase = Application.get_env(:ex_falcon, :passphrase)
    secret_key = Application.get_env(:ex_falcon, :secret_key)

    timestamp = Sign.timestamp()

    message = timestamp <> "GET" <> "/socket.io"

    [
      {"FX-ACCESS-KEY", api_key},
      {"FX-ACCESS-SIGN", Sign.generate_signature(message, secret_key)},
      {"FX-ACCES-TIMESTAMP", timestamp},
      {"FX-ACCESS-PASSPHRASE", passphrase}
    ]
  end
end
