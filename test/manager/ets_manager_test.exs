defmodule Virgil.Manager.EtsManagerTest do
  use ExUnit.Case, async: false

  alias Virgil.Manager.ETSManager, as: Manager

  @circuit_name Test

  test "is_closed?/1 returns true when circuit is closed" do
    assert {:ok, true} = Manager.is_closed?(@circuit_name)
  end

  test "close/1" do
    assert :ok = Manager.close(@circuit_name)
  end

  test "open/1" do
    assert :ok = Manager.open(@circuit_name)
  end

  test "increment_error_counter/1" do
    assert {:ok, 1} = Manager.increment_error_counter(@circuit_name)
  end

  test "decrement_error_counter/1" do
    assert {:ok, 0} = Manager.decrement_error_counter(@circuit_name)
  end
end
