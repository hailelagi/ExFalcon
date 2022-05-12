defmodule ExFalcon.MixProject do
  use Mix.Project

  @source_url "https://github.com/hailelagi/ExFalcon"
  @version "0.1.0"

  def project do
    [
      app: :ex_falcon,
      version: @version,
      elixir: "~> 1.13",
      name: "ExFalcon",
      source_url: @source_url,
      homepage_url: @source_url,
      deps: deps(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:excoveralls, "~> 0.13", only: :test},
    ]
  end

  defp docs do
    [
      main: "ExFalcon",
      logo: nil,
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      description: "FalconX (https://falconx.io/) elixir client.",
      maintainers: ["hailelagi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/hailelagi/ExFalcon"
      }
    ]
  end
end
