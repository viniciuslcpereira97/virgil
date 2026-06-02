defmodule Virgil.Telemetry.CircuitHandler do
  @moduledoc false

  require Logger

  alias Virgil.Config
  alias Virgil.Manager.Logic.Circuit, as: Logic

  def handle_event([:virgil, :circuit, :success], _measurements, %{circuit: circuit_module}, _config),
    do: Logger.debug("[#{__MODULE__}] [#{circuit_module}] Received success event")

  def handle_event(
        [:virgil, :circuit, :failure],
        _measurements,
        %{circuit: circuit_module},
        _config
      ) do
    Logger.debug("[#{__MODULE__}] [#{circuit_module}] Received failure event")

    adapter = Config.circuit_manager().adapter()

    %_{error_threshold: error_threshold} = circuit = circuit_module.circuit()
    {:ok, error_counter} = adapter.increment_error_counter(circuit)

    if Logic.threshold_reached?(error_counter, error_threshold),
      do: adapter.open(circuit)
  end
end
