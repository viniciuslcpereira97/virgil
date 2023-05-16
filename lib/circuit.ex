defmodule Virgil.Circuit do
  @callback run ::
              :ok
              | :error
              | {:ok, any()}
              | {:error, any()}

  defmacro __using__(opts) do
    quote do
      @behaviour Virgil.Circuit

      opts = unquote(opts)

      alias __MODULE__, as: Circuit

      @error_threshold opts[:error_threshold] || 5

      @callback run ::
                  :ok
                  | :error
                  | {:ok, any()}
                  | {:error, any()}

      @spec error_threshold :: integer()
      def error_threshold, do: @error_threshold
    end
  end
end
