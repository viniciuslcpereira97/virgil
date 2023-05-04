defmodule CircuitBreaker.Circuit do

  @callback run :: any()
  @callback circuit_name :: atom()
  @callback error_threshold :: integer()

  defmacro __using__(opts) do
    quote do
      opts = unquote(opts)

      error_threshold = opts[:error_threshold] || 5
      circuit_name = opts[:circuit_name]

      IO.inspect(error_threshold, label: :error_threshold)
      IO.inspect(circuit_name, label: :circuit_name)
    end
  end
end
