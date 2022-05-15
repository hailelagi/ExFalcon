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
  ```
    ExFalcon.get_trading_pairs()
    [%{base_token: "BTC", quote_token: "USD"}, %{base_token: "ETH", quote_token: "USD"}]
  ```
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
  @spec get_quote(T.token_pair(), T.quantity(), T.side()) :: T.quote_response() | T.error()
  def get_quote(token_pair, quantity, side) do
    params = [token_pair: token_pair, quantity: quantity, side: Atom.to_string(side)]

    case Client.get_quote(params) do
      {:ok, fx_quotes} -> fx_quotes
      error -> error
    end
  end

  @doc """
   Get status of a quote by ID.

   ExFalcon.get_quote_status(("00c884b056f949338788dfb59e495377"))
  """
  @spec get_quote_status(String.t()) :: T.quote_response()
  def get_quote_status(fx_quote_id) do
    case Client.quotes(nil, fx_quote_id) do
      {:ok, fx_quote} -> fx_quote
      error -> error
    end
  end

  @doc """
  Executes a quote.

  Example:
  ```
    ExFalcon.execute_quote("00c884b056f949338788dfb59e495377", :buy)
  ```
  """
  @spec execute_quote(String.t(), T.side()) :: T.quote_response() | T.error()
  def execute_quote(id, side) do
    case Client.execute_quote(fx_quote_id: id, side: Atom.to_string(side)) do
      {:ok, fx_quote} -> fx_quote
      error -> error
    end
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
    params = [
      t_start: DateTime.to_iso8601(t_start),
      t_end: DateTime.to_iso8601(t_end),
      platform: Atom.to_string(platform),
      status: status
    ]

    case Client.quotes(params) do
      {:ok, fx_quote} -> fx_quote
      error -> error
    end
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
  @callback place_order(T.token_pair(), T.quantity(), T.side(), T.order_type(), T.order_options()) ::
              T.order_response() | T.error()
  def place_order(token_pair, quantity, side, order_type, opts \\ []) do
    params =
      [
        token_pair: token_pair,
        quantity: quantity,
        side: Atom.to_string(side),
        order_type: Atom.to_string(order_type)
      ] ++ opts

    case Client.place_order(params) do
      {:ok, order} -> order
      error -> error
    end
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
  @spec get_balances(T.platform()) :: [T.balance()] | T.error()
  def get_balances(platform) do
    case Client.balances(platform: platform) do
      {:ok, balances} -> balances
      error -> error
    end
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
    params = [
      t_start: DateTime.to_iso8601(t_start),
      t_end: DateTime.to_iso8601(t_end),
      platform: Atom.to_string(platform)
    ]

    case Client.transfers(params) do
      {:ok, txns} -> txns
      error -> error
    end
  end

  @doc """
    Get trading volume between the given time range.
  """
  @spec get_trade_volume(DateTime.t(), DateTime.t()) :: T.trade_volume() | T.error()
  def get_trade_volume(t_start, t_end) do
    params = [
      t_start: DateTime.to_iso8601(t_start),
      t_end: DateTime.to_iso8601(t_end),
    ]

    case Client.trade_volume(params) do
      {:ok, volume} -> volume
      error -> error
    end
  end

  @spec get_trade_limits(T.platform()) :: T.trade_limits() | T.error()
  def get_trade_limits(platform) do
    case Client.trade_limits(platform: Atom.to_string(platform)) do
      {:ok, limit} -> limit
      error -> error
    end
  end

  @doc """
  Fetches total balances for all tokens combined over all platforms.
  """
  def get_total_balances do
    case Client.total_balances do
      {:ok, balances} -> balances
      error -> error
    end
  end
end
