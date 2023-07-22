defmodule Virgil.MixProject do
  use Mix.Project

  @app :virgil
  @version "1.0.0"
  @github_url "https://github.com/viniciuslcpereira97/circuit-breaker"

  def project do
    [
      name: "Virgil",
      app: @app,
      version: @version,
      lockfile: "mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      package: package(),
      docs: docs(),
      description: "A simple Elixir package that provides circuit breaker manager"
    ]
  end

  defp package do
    [
      files: ~w(lib/manager/manager.ex mix.exs .formatter.exs),
      licenses: ["Apache-2.0"],
      links: %{GitHub: @github_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @github_url,
      source_ref: "v#{@version}",
      formatter_opts: [gfm: true],
      extras: ~w(README.md)
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
      {:libcluster, "~> 3.3.2"},
      {:ex_doc, ">= 0.19.0", only: :dev, runtime: false}
    ]
  end
end
