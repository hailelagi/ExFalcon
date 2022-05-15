defmodule ExFalcon.Client do
  @moduledoc """
    REST client for querying the FalconX API using HTTP calls.
  """
  @version "v1"

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.falconx.io/#{@version}")

  plug(Tesla.Middleware.Sign,
    api_key: Application.get_env(:ex_falcon, :api_key),
    passphrase: Application.get_env(:ex_falcon, :passphrase),
    secret_key: Application.get_env(:ex_falcon, :secret_key)
  )

  plug(Tesla.Middleware.JSON)

  def get_pairs do
    case Tesla.get("/pairs") do
      {:ok, tesla} -> tesla.body
      {:error, error} -> error
    end
  end
end
