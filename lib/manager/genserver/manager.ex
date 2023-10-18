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
  def increment_error_counter(_circuit), do: :ok

  @impl GenServer
  def handle_cast(:open, state),
    do: {:noreply, %Circuit{state | state: :open}}

  @impl GenServer
  def handle_cast(:close, state),
    do: {:noreply, %Circuit{state | state: :closed}}

  @impl GenServer
  def handle_call(:is_closed?, _from, state) do
    %{state: current_state} = state
  end
end
