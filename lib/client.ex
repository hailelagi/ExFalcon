defmodule ExFalcon.Client do
  @moduledoc """
    HTTP api calls
  """
  use Tesla

  # plug Tesla.Middleware.BaseUrl, "https://api.falconx.io"
  plug Tesla.Middleware.BaseUrl, "https://www.example.com"
  # plug Tesla.Middleware.Headers, [{"authorization", "token xyz"}]
  plug Tesla.Middleware.JSON

  def get() do
    get("/")
  end
end
