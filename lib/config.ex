defmodule CircuitBreaker.Config do
  @moduledoc false

  def table_name,
    do: Application.get_env(:circuit_breaker, :table_name) || :circuits

  def table_visibility,
    do: if Mix.env() == :dev, do: :public, else: :private

  def default_ttl,
    do: 10_000
end
