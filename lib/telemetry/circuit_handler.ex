defmodule Virgil.Telemetry.CircuitHandler do
  @moduledoc false

  require Logger

  alias Virgil.Config

  def handle_event([:virgil, :circuit, :success], _measurements, _metadata, _config) do
    Logger.debug("Success circuit event received")
  end

  def handle_event(
        [:virgil, :circuit, :failure],
        _measurements,
        %{circuit: circuit_module},
        _config
      ) do
    adapter = Config.circuit_manager().adapter()
    %_{error_threshold: error_threshold} = circuit = circuit_module.circuit()

    Logger.debug("[#{__MODULE__}] [#{circuit_module}] Received failure event")

    {:ok, error_counter} = adapter.increment_error_counter(circuit)

    if error_counter >= error_threshold,
      do: adapter.open(circuit)
  end
end
