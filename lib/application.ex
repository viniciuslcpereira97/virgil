defmodule Virgil.Application do
  @moduledoc false

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

    Virgil.Config.circuit_manager()
    |> startup_manager()
    |> Supervisor.start_link(name: Virgil.Supervisor, strategy: :one_for_one)
  end

  defp startup_manager(Virgil.Manager.ETSManager),
    do: [{Virgil.Manager.ETSManager, []}]

  defp startup_manager(Virgil.Manager.GenserverManager),
    do: [Virgil.Manager.Genserver.Supervisor]
end
