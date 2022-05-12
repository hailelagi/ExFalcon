defmodule ExFalcon.Client do
  @moduledoc """
    REST client for querying the FalconX API using HTTP calls.
  """
  use Tesla
  @version "v1"

  plug Tesla.Middleware.BaseUrl, "https://api.falconx.io/#{@version}"
  # plug Tesla.Middleware.Headers, [{"authorization", "token xyz"}]
  plug Tesla.Middleware.JSON


  def get() do
    get("/")
  end

  def build_client() do
    # add headers
    # auth
    # return tesla client for requests
  end

  def authenticate(_key, _secret, _passphrase) do
  end

  defp add_falcon_headers(_conn, _key, _secret, _passphrase) do
  # todo: add headers TO each request
  # FX-ACCESS-SIGN
  # FX-ACCESS-KEY
  # FX-ACCES-TIMESTAMP
  # FX-ACCESS-PASSPHRASE
  end
end
