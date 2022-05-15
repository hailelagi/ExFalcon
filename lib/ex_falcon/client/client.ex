defmodule ExFalcon.Client do
  @moduledoc """
    REST client for querying the FalconX API using HTTP calls.
  """
  @version "v1"

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "#{Application.get_env(:ex_falcon, :base_url)}")

  plug(Tesla.Middleware.Sign,
    api_key: Application.get_env(:ex_falcon, :api_key),
    passphrase: Application.get_env(:ex_falcon, :passphrase),
    secret_key: Application.get_env(:ex_falcon, :secret_key)
  )

  plug(Tesla.Middleware.JSON)

  def pairs, do: Tesla.get("/pairs") |> parse_response()

  def quotes(opts), do: Tesla.get("/quotes", body: opts) |> parse_response()

  def execute_quote(opts), do: Tesla.post("/quotes/execute", body: opts) |> parse_response()

  def executed_quotes, do: Tesla.get("/quotes")

  def place_order(opts), do: Tesla.post("/order", body: opts)

  def order_history, do: Tesla.get("/orders") |> parse_response()

  def balances, do: Tesla.get("/balances") |> parse_response()

  def total_balances, do: Tesla.get("/balances/total")

  def transfer(id), do: Tesla.get("/transfer/#{id}") |> parse_response()

  def transfers, do: Tesla.get("/transfers") |> parse_response()

  def thirty_day_trailing_volume, do: Tesla.get("/get_30_day_trailing_volume") |> parse_response()

  def trade_volume, do: Tesla.get("/get_trade_volume") |> parse_response()

  def token_balance_info(token), do: Tesla.get("/get_trade_volume#{token}") |> parse_response()

  def request_withdrawal(ref_id \\ nil, opts) do
    path = if ref_id == nil, do: "/submit_withdrawal_request", else: "withdraw"
    Tesla.post(path, opts) |> parse_response()
  end

  def rate_limit, do: Tesla.get("rate_limit/") |> parse_response()

  def trade_limits(platform), do: Tesla.get("/get_trade_limits/#{platform}") |> parse_response()

  def trade_sizes(), do: Tesla.get("/get_trade_sizes") |> parse_response()

  defp parse_response(request) do
    case request do
      {:ok, %{status: 200, body: %{status: "success"} = body}} -> {:ok, body}
      response -> parse_error(response)
    end
  end

  def parse_error(response) do
    # todo: handle Falcon errors
    case response do
      {:ok, %{status: 400, body: _body}} ->
        {:error, %{code: 400, reason: "Bad Request"}}

      {:ok, %{status: 401, body: _body}} ->
        {:error, %{code: 401, reason: "Invalid API Key"}}

      {:ok, %{status: 403, body: _body}} ->
        {:error, %{code: 403, reason: "Forbidden"}}

      {:ok, %{status: 404, body: _body}} ->
        {:error, %{code: 404, reason: "Resource Not Found"}}

      {:ok, %{status: 500, body: _body}} ->
        {:error, %{code: 500, reason: "Internal Server Error"}}
    end
  end
end
