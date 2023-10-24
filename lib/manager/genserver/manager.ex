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
  def handle_cast(:open, state),
    do: {:noreply, %Circuit{state | state: :open}}

  @impl GenServer
  def handle_cast(:close, state),
    do: {:noreply, %Circuit{state | state: :closed}}

  @impl GenServer
  def handle_call(:is_closed?, _from, state) do
    %Circuit{state: current_state} = state

    {:reply, {:ok, current_state == :closed}, state}
  end

  @impl GenServer
  def handle_call(:increment_failures, _from, state) do
    %Circuit{failures: current_failures} = state

    {:reply, {:ok, current_failures + 1}, %Circuit{state | failures: current_failures + 1}}
  end
end
