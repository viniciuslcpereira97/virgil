defmodule CircuitBreaker.ManagerServer do
  @moduledoc """
  Inicia as tabelas utilizadas para armazenar o estado dos circuitos e o processo que gerencia esses estados.
  """

  use GenServer

  require Logger

  alias CircuitBreaker.Config

  @server_name :circuit_manager

  @errors_table :circuit_errors

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @server_name)
  end

  @impl GenServer
  def init(_state) do
    :ets.new(Config.table_name(), [:set, Config.table_visibility(), :named_table])
    :ets.new(@errors_table, [:set, :private, :named_table])

    {:ok, self()}
  end

  @impl GenServer
  def handle_call({:is_closed?, circuit}, _from, state) do
    Logger.info("[#{__MODULE__}] Checking if circuit #{circuit} is closed")

    case :ets.lookup(Config.table_name(), circuit) do
      [] ->
        Logger.info("[#{__MODULE__}] Circuit #{circuit} is closed")
        {:reply, true, state}

      [_] ->
        Logger.info("[#{__MODULE__}] Circuit #{circuit} is open")
        {:reply, false, state}
    end
  end

  @impl GenServer
  def handle_call({:increase_error_counter, circuit}, _from, state) do
    Logger.info("[#{__MODULE__}] Increasing error counter for circuit #{circuit}")

    # first value in tuple is the position to increment in ets stored tuple
    # the second value is the value to increment
    increment_operation = {2, 1}
    default_tuple = {circuit, 0}

    counter = :ets.update_counter(@errors_table, circuit, increment_operation, default_tuple)

    {:reply, counter, state}
  end

  # TODO: Decrease until the value reaches 0
  @impl GenServer
  def handle_call({:decrease_error_counter, circuit}, _from, state) do
    Logger.info("[#{__MODULE__}] Decreasing error counter for circuit #{circuit}")

    decrement_operation = {2, -1}

    counter = :ets.update_counter(@errors_table, circuit, decrement_operation)

    {:reply, counter, state}
  end

  @impl GenServer
  def handle_cast({:open, circuit}, state) do
    Logger.info("[#{__MODULE__}] Openning circuit #{circuit}")

    :ets.insert(Config.table_name(), {circuit, [openned_at: DateTime.utc_now()]})

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:close, circuit}, state) do
    Logger.info("[#{__MODULE__}] Closing circuit #{circuit}")

    :ets.delete(Config.table_name(), circuit)

    {:noreply, state}
  end
end
