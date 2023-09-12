defmodule Virgil.Telemetry.CircuitHandler do
  require Logger

  alias Virgil.Config

  def handle_event([:virgil, :circuit, :success], _measurements, _metadata, _config) do
    Logger.debug("Success circuit event received")
  end

  def handle_event([:virgil, :circuit, :failure], _measurements, %{circuit: circuit}, _config) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Received failure event")

    {:ok, error_counter} = circuit_manager().increment_error_counter(circuit)

    if error_counter >= circuit.error_threshold() do
      circuit_manager().open(circuit)
    end
  end

  defp circuit_manager, do: Config.manager()
end
