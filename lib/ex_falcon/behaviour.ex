defmodule ExFalcon.Behaviour do
  @moduledoc false

  @callback get_trading_pairs() :: [ExFalcon.token_pair()] | ExFalcon.error()

  @callback get_quote(%{
              token_pair: ExFalcon.token_pair(),
              quantity: ExFalcon.quantity(),
              side: ExFalcon.side()
            }) :: ExFalcon.quote_response() | ExFalcon.error()

  @callback place_order(%{
              :token_pair => ExFalcon.token_pair(),
              :quantity => ExFalcon.quantity(),
              :side => ExFalcon.side(),
              :order_type => ExFalcon.order_type(),
              optional(:time_inforce) => String.t(),
              optional(:limit_price) => float(),
              optional(:slippage_bps) => non_neg_integer()
            }) :: ExFalcon.order_response() | ExFalcon.error()

  @callback execute_quote(%{fx_quote_id: String.t(), side: ExFalcon.side()}) ::
              ExFalcon.quote_response() | ExFalcon.error()

  @callback get_quote_status(fx_quote_id :: String.t()) ::
              ExFalcon.quote_response() | ExFalcon.error()

  @callback get_executed_quotes(
              t_start :: DateTime.t(),
              t_end :: DateTime.t(),
              platform :: ExFalcon.platform(),
              status :: String.t()
            ) ::
              [ExFalcon.quote_response()] | ExFalcon.error()

  @callback get_balances(platform :: ExFalcon.platform()) ::
              [ExFalcon.balance()] | ExFalcon.error()

  @callback get_transfers(
              t_start :: DateTime.t(),
              t_end :: DateTime.t(),
              platform :: ExFalcon.platform()
            ) ::
              [ExFalcon.transfer()] | ExFalcon.error()

  @callback get_trade_volume(t_start :: DateTime.t(), t_end :: DateTime.t()) ::
              ExFalcon.trade_volume() | ExFalcon.error()

  @callback get_trade_limits(platform :: ExFalcon.platform()) ::
              ExFalcon.trade_limits() | ExFalcon.error()

  @callback get_total_balances() :: ExFalcon.total_balance() | ExFalcon.error()

  # @deprecated in py | js client library but not present in api doc
  # @callback get_trade_sizes() :: trade_size() | error()

  # todo:
  # @callback submit_withdrawal_request(token, amount, platform)
  # @callback get_30_day_trailing_volume()
  # @callback get_rate_limits()
  # todo:
  # websocket
end
