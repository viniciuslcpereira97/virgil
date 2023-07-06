defmodule Virgil.Telemetry.CircuitHandler do
  require Logger

  alias Virgil.Config

  def handle_event([:virgil, :circuit, :success], _measurements, _metadata, _config) do
    # Logger.info("Success circuit event received")
    :ok
  end

  def handle_event([:virgil, :circuit, :failure], _measurements, %{circuit: circuit}, _config) do
    Logger.info("[#{__MODULE__}] [#{circuit}] Received failure event")

    {:ok, error_counter} = circuit_manager().increment_error_counter(circuit)

    if error_counter >= circuit.error_threshold() do
      circuit_manager().open(circuit)
    end
  end

  defp circuit_manager, do: Config.manager()
end
