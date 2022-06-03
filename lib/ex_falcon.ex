defmodule ExFalcon do
  @moduledoc """
    ExFalcon is a library that wraps the FalconX API.
  """
  # TODO:
  # cleanup broken function signature
  # test


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
  @type order_options :: %{
          time_inforce: String.t(),
          limit_price: float(),
          slippage_bps: non_neg_integer()
        }

  ### error types ###
  @type error :: {:error, falcon_x_error()}
  @type falcon_x_warning :: %{code: String.t(), message: String.t(), side: side()}
  @type falcon_x_error :: %{code: String.t(), reason: String.t()}

  @doc """
  Gets a list of trading pairs you are eligible to trade.

  Example:
  ```
    ExFalcon.get_trading_pairs()
    [%{base_token: "BTC", quote_token: "USD"}, %{base_token: "ETH", quote_token: "USD"}]
  ```
  """
  # @spec get_trading_pairs() :: [token_pair()] | error()
  # def get_trading_pairs do
  #   case Client.pairs() do
  #     {:ok, pairs} -> pairs
  #     error -> error
  #   end
  # end

  @doc """
  Gets a two_way, buy or sell quote for a token pair.

  Example:
  ```
    ExFalcon.get_quote(
      %{
        "base_token": "BTC",
        "quote_token": "USD"
      },
      %{
        "token": "BTC",
        "value": "10"
        }, :buy)

    %{
      "status" => "success",
      "fx_quote_id" => "00c884b056f949338788dfb59e495377",
      "buy_price" => 12650,
      "sell_price" => nil,
      "token_pair" => {
        "base_token" => "BTC",
        "quote_token": "USD"
      },
      "quantity_requested" => %{
        "token" => "BTC",
        "value" => "10"
      },
      "side_requested" => "buy",
      "t_quote" => "2019-06-27T11:59:21.875725+00:00",
      "t_expiry" => "2019-06-27T11:59:22.875725+00:00",
      "is_filled" => false,
      "side_executed" => nil,
      "price_executed" => nil,
      "t_execute" => nil,
      "client_order_id" => "d6f3e1fa-e148-4009-9c07-a87f9ae78d1a"
    }
  ```
  """
  @spec get_quote(token_pair(), quantity(), side()) :: quote_response() | error()
  def get_quote(token_pair, quantity, side) do
    params = %{token_pair: token_pair, quantity: quantity, side: Atom.to_string(side)}

    impl().get_quote(params)
  end

  @doc """
   Get status of a quote by ID.

   ExFalcon.get_quote_status(("00c884b056f949338788dfb59e495377"))
  """

  # @spec get_quote_status(String.t()) :: quote_response()
  # def get_quote_status(fx_quote_id) do
  #   case Client.quotes(nil, fx_quote_id) do
  #     {:ok, fx_quote} -> fx_quote
  #     error -> error
  #   end
  # end

  @doc """
  Executes a quote.

  Example:
  ```
    ExFalcon.execute_quote("00c884b056f949338788dfb59e495377", :buy)
  ```
  """
  @spec execute_quote(String.t(), side()) :: quote_response() | error()
  def execute_quote(id, side) do
    impl().execute_quote(%{fx_quote_id: id, side: Atom.to_string(side)})
  end

  @doc """
  Get executed quotes between the given time range.

  Example:
  ```
    ExFalcon.get_executed_quotes(
      DateTime.utc_now(),
      DateTime.utc_now() |> DateTime.add(-36000, :second) |> to_string,
      :api, nil)
  ```

    Options
      - `status`: Filter by status, possible values: success, failure or null.
        if nil all results will be returned (default is success).

  """
  def get_executed_quotes(t_start, t_end, platform, status \\ "success") do
    params = %{
      t_start: DateTime.to_iso8601(t_start),
      t_end: DateTime.to_iso8601(t_end),
      platform: Atom.to_string(platform),
      status: status
    }

    impl().get_executed_quotes(params)
  end

  @doc """
    Place a market or limit order with FalconX.

    Example:
    - Market Order
    ```
    ExFalcon.place_order(
      %{base_token: "BTC", quote_token: "USD},
      %{token: "BTC", value: "10"},
      :buy, :market)
    ```

    - Limit Order
    ```
    ExFalcon.place_order(
      %{base_token: "BTC", quote_token: "USD},
      %{token: "BTC", value: "10"},
      :buy, :limit,
      opts: [time_inforce: "fok", limit_price: 8547.11, slippage_bps: 2])
    ```

    ## Options
      Required if order_type is a `:limit`
      - `time_in_force`: has the value "fok"
      - `limit_price` : Limit price of the order in the units of quote_token
      - `slippage_bps` : base points
  """
  @callback place_order(token_pair(), quantity(), side(), order_type(), order_options()) ::
              order_response() | error()
  def place_order(token_pair, quantity, side, order_type, opts \\ %{}) do
    params =
      %{
        token_pair: token_pair,
        quantity: quantity,
        side: Atom.to_string(side),
        order_type: Atom.to_string(order_type)
      }
      |> Map.merge(opts)

    impl().place_order(params)
  end

  @doc """
  Fetches balances for all tokens.

  Example:
    ```
      ExFalcon.get_balances(:api)

    [
        %{
          token: "BTC",
          balance: 10,
          platform: "api"
        },
        %{
          token: "ETH",
          balance: 100,
          platform: "api"
        }
    ]
    ```
  """
  @spec get_balances(platform()) :: [balance()] | error()
  def get_balances(platform) do
    impl().balances(platform: platform)
  end

  @doc """
    Get deposits / withdrawals between the given time range.

    Example:
    ```
      ExFalcon.get_transfers(
        DateTime.utc_now(),
        DateTime.utc_now() |> DateTime.add(-36000, :second) |> to_string,
        :browser,
      )

    [%{
      "type": "deposit",
      "platform": "browser",
      "token": "BTC",
      "quantity": 1.0,
      "status": "completed",
      "t_create": "2019-06-20T01:01:01+00:00"
    }]
    ```
  """
  def get_transfers(t_start, t_end, platform) do
    params = %{
      t_start: DateTime.to_iso8601(t_start),
      t_end: DateTime.to_iso8601(t_end),
      platform: Atom.to_string(platform)
    }

    impl().transfers(params)
  end

  @doc """
    Get trading volume between the given time range.
  """
  @spec get_trade_volume(DateTime.t(), DateTime.t()) :: trade_volume() | error()
  def get_trade_volume(t_start, t_end) do
    params = %{t_start: DateTime.to_iso8601(t_start), t_end: DateTime.to_iso8601(t_end)}

    impl().trade_volume(params)
  end

  @spec get_trade_limits(platform()) :: trade_limits() | error()
  def get_trade_limits(platform) do
    # todo: Enum.reject() unknown platform b4 atomization
    impl().trade_limits(platform: Atom.to_string(platform))
  end

  @doc """
  Fetches total balances for all tokens combined over all platforms.
  """
  def get_total_balances do
    impl().total_balances()
  end

  defp impl, do: Application.get_env(:ex_falcon, :api, ExFalcon.Client)
end
