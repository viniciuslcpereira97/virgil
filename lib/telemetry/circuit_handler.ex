defmodule CircuitBreaker.Telemetry.CircuitHandler do
  require Logger

  def handle_event([:circuit_breaker, :circuit, :success], _measurements, _metadata, _config) do
    Logger.info("Success circuit event received")
  end

  def handle_event([:circuit_breaker, :circuit, :failure], _measurements, _metadata, _config) do
    Logger.info("Failure circuit event received")
  end
end
