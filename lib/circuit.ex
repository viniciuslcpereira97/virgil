defmodule Virgil.Circuit do
  @moduledoc """
  Circuit implementation
  """

  @type t :: %__MODULE__{
    name: atom(),
    error_threshold: integer(),
    reset_timeout: integer(),
    failures: integer(),
    state: :open | :closed | :half_open
  }

  defstruct name: nil,
    error_threshold: 0,
    reset_timeout: 0,
    failures: 0,
    state: nil

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

      @error_threshold opts[:error_threshold] || Config.default_error_threshold()
      @reset_timeout opts[:reset_timeout] || Config.default_reset_timeout()

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

      @spec reset_timeout :: integer()
      def reset_timeout, do: @reset_timeout

      def circuit do
        %Virgil.Circuit{
          name: Circuit,
          failures: 0,
          state: :closed,
          error_threshold: @error_threshold,
          reset_timeout: @reset_timeout
        }
      end

      defp circuit_manager, do: Config.circuit_manager()

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
