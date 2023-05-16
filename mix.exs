defmodule Virgil.MixProject do
  use Mix.Project

  def project do
    [
      app: :virgil,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  def application do
    [
      mod: {Virgil.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:telemetry, "~> 1.2.1"},
      {:libcluster, "~> 3.3.2"}
    ]
  end
end
