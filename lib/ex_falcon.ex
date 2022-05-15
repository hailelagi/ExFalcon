defmodule ExFalcon do
  @moduledoc """
    ExFalcon is a library that wraps the FalconX API.
  """
  @behaviour ExFalcon.Behaviour

  alias ExFalcon.Behaviour, as: T
  alias ExFalcon.Client

  @doc """
  Gets a list of trading pairs you are eligible to trade.

  Example:
  ExFalcon.get_trading_pairs()
  [{'base_token': 'BTC', 'quote_token': 'USD'}, {'base_token': 'ETH', 'quote_token': 'USD'}]
  """

  @spec get_trading_pairs() :: [T.token_pair()] | T.error()
  def get_trading_pairs do
    case Client.pairs() do
      {:ok, pairs} -> pairs
      error -> error
    end
  end

  @doc """
  Gets a two_way, buy or sell quote for a token pair.

  Example:
    ExFalcon.get_quote("BTC", "USD", 10, :buy)

    {
      "status": "success",
      "fx_quote_id": "00c884b056f949338788dfb59e495377",
      "buy_price": 12650,
      "sell_price": null,
      "token_pair": {
        "base_token": "BTC",
        "quote_token": "USD"
      },
      "quantity_requested": {
        "token": "BTC",
        "value": "10"
      },
      "side_requested": "buy",
      "t_quote": "2019-06-27T11:59:21.875725+00:00",
      "t_expiry": "2019-06-27T11:59:22.875725+00:00",
      "is_filled": false,
      "side_executed": null,
      "price_executed": null,
      "t_execute": null,
      "client_order_id": "d6f3e1fa-e148-4009-9c07-a87f9ae78d1a"
    }
  """
  @spec get_quote(String.t(), String.t(), float(), T.side()) :: T.quote_response() | T.error()
  def get_quote(base, fx_quote, quantity, side) do
    opts = [base: base, quote: fx_quote, quantity: quantity, side: side]

    case Client.quotes(opts) do
      {:ok, fx_quote} -> fx_quote
      error -> error
    end
  end

  def place_order(
        base,
        fx_quote,
        quantity,
        side,
        order_type,
        time_in_force,
        limit_price,
        slippage_bps
      ) do
  end

  def execute_quote(fx_quote_id, side) do
    nil
  end

  def get_quote_status(fx_quote_id) do
    nil
  end

  def get_executed_quotes(t_start, t_end, platform) do
    nil
  end

  def get_balances(platform) do
    nil
  end

  def get_transfers(t_start, t_end, platform) do
    nil
  end

  def get_trade_volume(t_start, t_end) do
    nil
  end

  def get_trade_limits(platform) do
    nil
  end

  def get_trade_sizes do
    nil
  end

  def get_trade_sizes do
    nil
  end

  def get_total_balances do
    nil
  end
end
