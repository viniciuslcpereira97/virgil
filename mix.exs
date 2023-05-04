defmodule CircuitBreaker.MixProject do
  use Mix.Project

  def project do
    [
      app: :circuit_breaker,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {CircuitBreaker.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:telemetry, "~> 1.2.1"}
    ]
  end
end
