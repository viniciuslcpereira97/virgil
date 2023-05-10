defmodule CircuitBreaker.Circuit do
  @callback run :: any()

  defmacro __using__(opts) do
    quote do
      @behaviour CircuitBreaker.Circuit

      @type circuit_name :: atom()
      @type error_threshold :: integer()

      opts = unquote(opts)

      @error_threshold opts[:error_threshold] || 5
      @circuit_name opts[:circuit_name]

      @callback run ::
                  :ok
                  | :error
                  | {:ok, any()}
                  | {:error, any()}

      @spec circuit_name :: String.t()
      def circuit_name, do: @circuit_name

      @spec error_threshold :: error_threshold()
      def error_threshold, do: @error_threshold
    end
  end
end
