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

      require Logger

      alias Virgil.Config
      alias __MODULE__, as: Circuit

      @error_threshold opts[:error_threshold] || 5

      @callback run ::
                  {:ok, any()}
                  | {:error, any()}

      @spec execute(any()) :: {:ok, any()} | {:error, any()}
      def execute(params) do
        {:ok, is_closed?} = circuit_manager().is_closed?(__MODULE__)

        if is_closed? do
          Logger.info("[#{__MODULE__}] Running circuit")

          params
          |> Circuit.run()
          |> handle_circuit_response()
        else
          Logger.info("[#{__MODULE__}] Circuit is not closed")
        end
      end

      @spec error_threshold :: integer()
      def error_threshold, do: @error_threshold

      defp handle_circuit_response({:ok, response}) do
        :telemetry.execute([:virgil, :circuit, :success], %{circuit_response: response}, %{
          circuit: __MODULE__
        })

        {:ok, []}
      end

      defp handle_circuit_response({:error, response}) do
        :telemetry.execute([:virgil, :circuit, :failure], %{circuit_response: response}, %{
          circuit: __MODULE__
        })

        {:error, []}
      end

      defp handle_circuit_response(_) do
        raise """
        Circuit response is invalid
        """
      end

      defp circuit_manager, do: Config.manager()
    end
  end
end
