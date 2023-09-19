defmodule Virgil.Circuit do
  @callback run(any()) :: {:ok, any()} | {:error, any()}

  defmacro __using__(opts) do
    quote do
      @behaviour Virgil.Circuit

      opts = unquote(opts)

      require Logger

      alias Virgil.{
        Config,
        Handler
      }

      alias __MODULE__, as: Circuit

      @error_threshold opts[:error_threshold] || 5

      @spec execute(any()) :: {:ok, any()} | {:error, any()}
      def execute(params) do
        {:ok, is_closed?} = circuit_manager().is_closed?(__MODULE__)

        if is_closed? do
          Logger.info("[#{__MODULE__}] Running circuit")

          params
          |> run()
          |> handle_response()
        else
          Logger.info("[#{__MODULE__}] Circuit is not closed")
        end
      end

      @spec error_threshold :: integer()
      def error_threshold, do: @error_threshold

      defp circuit_manager, do: Config.manager()

      defp handle_response({:ok, response}) do
        :telemetry.execute(
          [:virgil, :circuit, :success],
          %{circuit_response: response},
          %{
            circuit: Circuit
          }
        )
      end

      defp handle_response({:error, response}) do
        :telemetry.execute(
          [:virgil, :circuit, :failure],
          %{circuit_response: response},
          %{
            circuit: Circuit
          }
        )
      end
    end
  end
end
