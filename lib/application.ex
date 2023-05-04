defmodule CircuitBreaker.Application do
  use Application

  alias CircuitBreaker.ManagerServer
  alias CircuitBreaker.Telemetry.CircuitHandler

  def start(_type, _args) do
    attach_telemetry()

    Supervisor.start_link([ManagerServer], strategy: :one_for_one)
  end

  defp attach_telemetry do
    :telemetry.attach_many(
      "circuit-breaker-manager-handler",
      [
        [:circuit_breaker, :circuit, :failure],
        [:circuit_breaker, :circuit, :success]
      ],
      &CircuitHandler.handle_event/4,
      nil
    )
  end
end
