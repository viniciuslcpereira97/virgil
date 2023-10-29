defmodule Virgil.Manager.Genserver.Supervisor do
  @moduledoc false

  use Supervisor

  alias Virgil.Config
  alias Virgil.Manager.GenserverManager

  def init(_arg) do
    children = Enum.map(Config.registered_circuits(), &build_circuit_spec(&1.circuit()))

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(init_arg),
    do: Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)

  defp build_circuit_spec(%_{name: name} = circuit),
    do: Supervisor.child_spec({GenserverManager, circuit}, id: name)
end
