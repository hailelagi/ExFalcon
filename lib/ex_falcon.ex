defmodule ExFalcon do
  @moduledoc """
  todo: Documentation for `ExFalcon`.
  """
  @behaviour ExFalcon.Behaviour

  alias ExFalcon.Client

  def get_trading_pairs do
    Client.get_pairs()
  end

  def get_quote(base, fx_quote, quantity, side) do
    nil
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
