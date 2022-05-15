defmodule ExFalcon.Behaviour do
  @moduledoc """
    Expected type signature/data model and behaviour for the
    falcon library to implement.
  """

  ### api types ####
  @type token_pair :: %{base_token: String.t(), quote_token: String.t()}
  @type quantity :: %{token: String.t(), value: float()}
  @type balance :: %{token: String.t(), balance: float(), platform: platform()}
  @type total_balance :: %{token: String.t(), total_balance: float()}
  @type transfer :: %{
          type: String.t(),
          platform: platform(),
          token: String.t(),
          quantity: quantity(),
          create_time: DateTime.t(),
          status: String.t()
        }
  @type trade_volume :: %{
          start_date: DateTime.t(),
          end_date: DateTime.t(),
          usd_volume: float()
        }
  @type trade_limit :: %{available: float(), total: float(), used: float()}
  @type trade_size_limit :: %{min: float(), max: float()}
  @type trade_limits :: %{gross_limits: trade_limit(), net_limits: trade_limit()}
  @type trade_size :: %{
          platform: platform(),
          token_pair: token_pair(),
          trade_size_limit_quote_token: trade_size_limit()
        }

  ### api response types ###
  @type quote_response :: %{
          status: String.t(),
          fx_quote_id: String.t(),
          buy_price: float(),
          sell_price: float(),
          platform: platform(),
          token_pair: token_pair(),
          quantity: quantity(),
          position_in: quantity(),
          position_out: quantity(),
          side_requested: String.t(),
          quote_time: DateTime.t(),
          expiry_time: DateTime.t(),
          execution_time: DateTime.t(),
          is_filled: boolean(),
          trader_email: String.t(),
          error: falcon_x_error(),
          warnings: falcon_x_warning(),
          client_order_id: String.t()
        }

  @type order_response :: %{
          status: String.t(),
          fx_quote_id: String.t(),
          buy_price: float(),
          sell_price: float(),
          platform: platform(),
          token_pair: token_pair(),
          quantity: quantity(),
          side_requested: String.t(),
          quote_time: DateTime.t(),
          expiry_time: DateTime.t(),
          execution_time: DateTime.t(),
          is_filled: boolean(),
          gross_fee_bps: float(),
          gross_fee_usd: float(),
          rebate_bps: float(),
          rebate_usd: float(),
          fee_bps: float(),
          fee_usd: float(),
          side_executed: String.t(),
          trader_email: String.t(),
          order_type: order_type(),
          time_in_force: String.t(),
          limit_price: float(),
          slippage_bps: float(),
          error: falcon_x_error(),
          warnings: falcon_x_warning(),
          client_order_id: String.t()
        }

  ### helper types ###
  @type side :: :two_way | :buy | :sell
  @type platform :: :browser | :api | :margin
  @type order_type :: :market | :limit
  @type order_options :: [
          time_inforce: String.t(),
          limit_price: float(),
          slippage_bps: non_neg_integer()
        ]

  ### error types ###
  @type error :: {:error, falcon_x_error()}
  @type falcon_x_warning :: %{code: String.t(), message: String.t(), side: side()}
  @type falcon_x_error :: %{code: String.t(), reason: String.t()}

  ### behaviour ###
  @callback get_trading_pairs() :: [token_pair()] | error()

  @callback get_quote(
              token_pair :: token_pair(),
              quantity :: quantity(),
              side :: side()
            ) :: quote_response() | error()

  @callback place_order(
              token_pair :: token_pair(),
              quantity :: quantity(),
              side :: side(),
              order_type :: order_type(),
              opts: order_options()
            ) :: order_response() | error()

  @callback execute_quote(fx_quote_id :: String.t(), side :: side()) :: quote_response() | error()

  @callback get_quote_status(fx_quote_id :: String.t()) :: quote_response() | error()

  @callback get_executed_quotes(
              t_start :: DateTime.t(),
              t_end :: DateTime.t(),
              platform :: platform(),
              status :: String.t()
            ) ::
              [quote_response()] | error()

  @callback get_balances(platform :: platform()) :: [balance()] | error()

  @callback get_transfers(t_start :: DateTime.t(), t_end :: DateTime.t(), platform :: platform()) ::
              [transfer()] | error()

  @callback get_trade_volume(t_start :: DateTime.t(), t_end :: DateTime.t()) :: trade_volume() | error()

  @callback get_trade_limits(platform :: platform()) :: trade_limits() | error()

  @callback get_total_balances() :: total_balance() | error()

  # @deprecated in py | js client library but not present in api doc
  # @callback get_trade_sizes() :: trade_size() | error()

  # todo:
  # @callback submit_withdrawal_request(token, amount, platform)
  # @callback get_30_day_trailing_volume()
  # @callback get_rate_limits()
  # todo:
  # websocket
end
