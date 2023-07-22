defmodule FakeCircuitTest do
  use ExUnit.Case, async: false

  @circuit FakeCircuit

  alias Virgil.Manager.ETSManager, as: Manager

  test "manager opens the circuit when it reaches the threshold limit" do
    assert {:ok, true} = Manager.is_closed?(@circuit)

    for _ <- 1..4, do: Manager.increment_error_counter(@circuit)
  end
end
