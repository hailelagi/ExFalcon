defmodule ExFalcon.Client.Access do
  @moduledoc """
    Dynamically modify Client headers with a
    custom middleware
  """
  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, options) do
    env
    |> inspect_headers(options)
    |> Tesla.run(next)
    |> inspect_headers(options)
  end

  defp inspect_headers(env, options) do
    IO.inspect(env.headers, options)
  end
end
