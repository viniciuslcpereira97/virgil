defmodule Virgil.Manager.ETSManager do
  @moduledoc false

  use GenServer

  require Logger

  alias Virgil.Config

  @ets_table :circuits

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: :ets_manager)
  end

  @impl GenServer
  def init(_args) do
    initialize_tables()

    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:is_closed?, circuit}, _from, state) do
    [{_circuit, %{state: circuit_state}}] = :ets.lookup(@ets_table, circuit)

    Logger.debug("[#{__MODULE__}] [#{circuit}] Circuit is #{circuit_state}")

    {:reply, circuit_state == :closed, state}
  end

  @impl GenServer
  def handle_call({:increment_counter, circuit}, _from, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Incrementing error counter")

    [{circuit_name, %{failures: current_counter} = circuit}] = :ets.lookup(@ets_table, circuit)

    updated_counter = current_counter + 1

    :ets.insert(@ets_table, {circuit_name, %{circuit | failures: updated_counter}})

    {:reply, {:ok, updated_counter}, state}
  end

  @impl GenServer
  def handle_cast({:close, circuit}, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Closing circuit")

    circuit_struct = circuit.circuit()

    :ets.insert(@ets_table, {circuit, %{circuit_struct | state: :closed, failures: 0}})

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:open, circuit}, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Openning circuit")

    circuit_struct = circuit.circuit()

    :ets.insert(@ets_table, {circuit, %{circuit_struct | state: :open, failures: 0}})

    schedule_circuit_openning(circuit, circuit.reset_timeout())

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:close, circuit}, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Closing circuit")

    circuit_struct = circuit.circuit()

    :ets.insert(@ets_table, {circuit, %{circuit_struct | state: :closed, failures: 0}})

    {:noreply, state}
  end

  defp schedule_circuit_openning(circuit, reset_timeout),
    do: Process.send_after(self(), {:close, circuit}, reset_timeout * 1_000)

  defp initialize_tables do
    :ets.new(@ets_table, [:named_table, :public, :set])

    case Config.registered_circuits() do
      [] -> nil
      nil -> nil
      _ -> initialize_circuits()
    end
  end

  defp initialize_circuits() do
    Config.registered_circuits()
    |> Enum.map(&{&1, &1.circuit()})
    |> Enum.each(&:ets.insert(:circuits, &1))
  end
end
