defmodule Virgil.Manager.ETSManager do
  use GenServer

  require Logger

  alias Virgil.{Config, Manager}

  @behaviour Manager

  @manager_server :ets_manager
  @ets_table :circuits

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: :ets_manager)
  end

  @impl GenServer
  def init(_args) do
    initialize_tables()

    {:ok, %{}}
  end

  @impl Manager
  def is_closed?(circuit) do
    is_closed? = GenServer.call(@manager_server, {:is_closed?, circuit})

    {:ok, is_closed?}
  end

  @impl Manager
  def close(circuit),
    do: GenServer.cast(@manager_server, {:close, circuit})

  @impl Manager
  def open(circuit),
    do: GenServer.cast(@manager_server, {:open, circuit})

  @impl Manager
  def increment_error_counter(circuit),
    do: GenServer.call(@manager_server, {:increment_counter, circuit})

  @impl Manager
  def decrement_error_counter(_),
    do: {:ok, 0}

  @impl GenServer
  def handle_call({:is_closed?, circuit}, _from, state) do
    [{_circuit, %{state: circuit_state}}] = :ets.lookup(@ets_table, circuit)

    Logger.debug("[#{__MODULE__}] [#{circuit}] Circuit is #{circuit_state}")

    {:reply, circuit_state == :closed, state}
  end

  @impl GenServer
  def handle_call({:increment_counter, circuit}, _from, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Incrementing error counter")

    [{circuit_name, %{error_counter: current_counter} = circuit}] =
      :ets.lookup(@ets_table, circuit)

    updated_counter = current_counter + 1

    :ets.insert(@ets_table, {circuit_name, %{circuit | error_counter: updated_counter}})

    {:reply, {:ok, updated_counter}, state}
  end

  @impl GenServer
  def handle_call({:decrement_counter, circuit}, _from, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Decrement error counter")

    [{_circuit, %{error_counter: current_counter} = circuit}] = :ets.lookup(@ets_table, circuit)

    :ets.insert(@ets_table, {circuit, %{circuit | error_counter: current_counter - 1}})

    {:reply, {:ok, current_counter - 1}, state}
  end

  @impl GenServer
  def handle_cast({:close, circuit}, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Closing circuit")

    :ets.insert(@ets_table, {circuit, %{state: :closed, error_counter: 0}})

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:open, circuit}, state) do
    Logger.debug("[#{__MODULE__}] [#{circuit}] Openning circuit")

    :ets.insert(@ets_table, {circuit, %{state: :open, error_counter: 0}})

    {:noreply, state}
  end

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
    |> Enum.map(&{&1, %{state: Config.default_circuit_state(), error_counter: 0}})
    |> Enum.each(&:ets.insert(:circuits, &1))
  end
end
