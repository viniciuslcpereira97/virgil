defmodule Virgil.Manager.EtsManagerTest do
  use ExUnit.Case, async: true

  alias Virgil.Manager.ETSManager, as: Manager

  @circuit_name Test

  test "ETS Manager full test" do
    assert {:ok, true} = Manager.is_closed?(@circuit_name)

    assert :ok = Manager.open(@circuit_name)
    assert {:ok, false} = Manager.is_closed?(@circuit_name)

    assert :ok = Manager.close(@circuit_name)
    assert {:ok, true} = Manager.is_closed?(@circuit_name)

    assert {:ok, 1} = Manager.increment_error_counter(@circuit_name)
    assert {:ok, 2} = Manager.increment_error_counter(@circuit_name)
    assert {:ok, 0} = Manager.decrement_error_counter(@circuit_name)
  end
end
