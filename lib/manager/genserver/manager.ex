defmodule Virgil.Manager.GenserverManager do
  @moduledoc false

  use GenServer

  require Logger

  alias Virgil.Circuit

  @behaviour Virgil.Manager

  def start_link(%{name: circuit_name} = circuit),
    do: GenServer.start_link(__MODULE__, circuit, name: circuit_name)

  @impl GenServer
  def init(circuit), do: {:ok, circuit}

  @impl Virgil.Manager
  def close(%Circuit{name: circuit_name}),
    do: GenServer.cast(circuit_name, :close)

  @impl Virgil.Manager
  def open(%Circuit{name: circuit_name}),
    do: GenServer.cast(circuit_name, :open)

  @impl Virgil.Manager
  def is_closed?(%Circuit{name: circuit_name}),
    do: GenServer.call(circuit_name, :is_closed?)

  @impl Virgil.Manager
  def increment_error_counter(%Circuit{name: circuit_name}),
    do: GenServer.call(circuit_name, :increment_failures)

  @impl GenServer
  def handle_cast(:open, %Circuit{name: circuit} = state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Openning circuit")

    {:noreply, %Circuit{state | state: :open}}
  end

  @impl GenServer
  def handle_cast(:close, %Circuit{name: circuit} = state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Closing circuit")

    {:noreply, %Circuit{state | state: :closed}}
  end

  @impl GenServer
  def handle_call(:is_closed?, _from, %Circuit{name: circuit, state: circuit_state} = state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Circuit is #{circuit_state}")

    {:reply, {:ok, circuit_state == :closed}, state}
  end

  @impl GenServer
  def handle_call(:increment_failures, _from, %Circuit{name: circuit, failures: current_failures} = state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Incrementig circuit failures")

    {:reply, {:ok, current_failures + 1}, %Circuit{state | failures: current_failures + 1}}
  end
end
