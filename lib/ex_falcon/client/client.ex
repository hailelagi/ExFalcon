defmodule ExFalcon.Client do
  @moduledoc """
    REST client for querying the FalconX API using HTTP calls.
  """
  @version "v1"
  def get_pairs do
    # baseMessage = timestamp + client.method + client.url;
    client = build_test()
    tesla = client |> Tesla.get("/pairs")

  tesla.method

  end

  def build_test do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://www.example.com"},
      ExFalcon.Client.Access,
      {Tesla.Middleware.Headers,
       [
         {"authorization", "ok"}
       ]},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  def build_client(client) do
    timestamp = timestamp()

    # prehash = timestamp + method + req_path + body
    base =""

    api_key = Application.get_env(:ex_falcon, :api_key)
    passphrase = Application.get_env(:ex_falcon, :passphrase)

    middleware = [
      #{Tesla.Middleware.BaseUrl,
      #"https://api.falconx.io/#{@version}"},
      {Tesla.Middleware.Headers,
       [
         {"FX-ACCESS-KEY", api_key},
         {"FX-ACCESS-SIGN", sign_message(base)},
         {"FX-ACCES-TIMESTAMP", timestamp},
         {"FX-ACCESS-PASSPHRASE", passphrase}
       ]},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  defp sign_message(message) do
    # sha 256 HMAC
    # base64.decode(secret)
    message
  end

  def timestamp do
    DateTime.utc_now() |> to_string()
  end
end
