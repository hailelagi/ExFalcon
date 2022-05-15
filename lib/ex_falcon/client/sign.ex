defmodule ExFalcon.Client.Sign do
  @moduledoc """
    Middleware to dynamically sign each client request with
    falconX headers.
    See: https://app.falconx.io/docs#authentication

    ## Examples

    ```
    def new(api_key, secret_key, passphrase) do
      Tesla.client(
        {Tesla.Middleware.Sign, [api_key: api_key, passphrase: passphrase, secret_key: secret_key]},
      )
    end
    ```

    ## Options
      - `:api_key` - The API key as a string
      - `:secret_key` -  base64-encoded secret
      - `:passphrase` - passphrase given
  """

  @behaviour Tesla.Middleware
  @impl Tesla.Middleware

  def call(env, next, options) do
    timestamp = timestamp()
    method = Atom.to_string(env.method) |> String.upcase()
    prehash = timestamp <> method <> env.url <> Tesla.encode_query(env.body)

    env
    |> Tesla.put_headers([
      {"FX-ACCESS-PASSPHRASE", options[:passphrase]},
      {"FX-ACCESS-KEY", options[:api_key]},
      {"FX-ACCESS-SIGN", generate_signature(prehash, options[:secret_key])},
      {"FX-ACCES-TIMESTAMP", timestamp},
      {"FX-ACCESS-PASSPHRASE", options[:passphrase]}
    ])
    |> Tesla.run(next)
  end

  defp generate_signature(message, secret) do
    with {:ok, key} <- Base.decode64(secret),
         {:ok, signature} <- :crypto.mac(:hmac, :sha256, key, message) do
      Base.encode64(signature)
    else
      _ -> {:error, "Bad secret key or passphrase"}
    end
  end

  defp timestamp do
    DateTime.utc_now() |> to_string()
  end
end
