defmodule Virgil.Application do
  use Application

  alias Virgil.Telemetry.CircuitHandler

  def start(_type, _args) do
    :telemetry.attach_many(
      "circuit-breaker-manager-handler",
      [
        [:virgil, :circuit, :failure],
        [:virgil, :circuit, :success]
      ],
      &CircuitHandler.handle_event/4,
      nil
    )

    children = [
      {Virgil.Manager.ETSManager, []}
    ]

    Supervisor.start_link(children, name: Virgil.Supervisor, strategy: :one_for_one)
  end
end
