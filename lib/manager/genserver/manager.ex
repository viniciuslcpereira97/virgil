defmodule Virgil.Manager.GenserverManager do
  @moduledoc false

  use GenServer

  require Logger

  alias Virgil.Circuit

  @impl true
  def init(circuit), do: {:ok, circuit}

  def adapter, do: Virgil.Manager.Genserver.Adapter

  def start_link(%{name: circuit_name} = circuit),
    do: GenServer.start_link(__MODULE__, circuit, name: circuit_name)

  @impl true
  def handle_cast(:open, %Circuit{name: circuit} = state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Openning circuit")

    {:noreply, %Circuit{state | state: :open}}
  end

  @impl true
  def handle_cast(:close, %Circuit{name: circuit} = state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Closing circuit")

    {:noreply, %Circuit{state | state: :closed}}
  end

  @impl true
  def handle_call(:is_closed?, _from, %Circuit{name: circuit, state: circuit_state} = state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Circuit is #{circuit_state}")

    {:reply, {:ok, circuit_state == :closed}, state}
  end

  @impl true
  def handle_call(
        :increment_failures,
        _from,
        %Circuit{name: circuit, failures: current_failures} = state
      ) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Incrementig circuit failures")

    {:reply, {:ok, current_failures + 1}, %Circuit{state | failures: current_failures + 1}}
  end
end
