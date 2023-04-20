defmodule CircuitBreaker.ManagerServer do
  @moduledoc """
  Inicia as tabelas utilizadas para armazenar o estado dos circuitos e o processo que gerencia esses estados.
  """

  use GenServer

  require Logger

  alias CircuitBreaker.Config

  @server_name :circuit_manager

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @server_name)
  end

  @impl GenServer
  def init(_state) do
    :ets.new(Config.table_name(), [:set, Config.table_visibility, :named_table])

    {:ok, self()}
  end

  @impl GenServer
  def handle_cast({:open, circuit}, _from),
    do: {:noreply, open(circuit)}

  @impl GenServer
  def handle_cast({:close, circuit}, _from),
    do: {:noreply, close(circuit)}

  defp open(circuit) do
    Logger.info("[#{__MODULE__}] Openning circuit #{circuit}")

    :ets.insert(Config.table_name(), {circuit, [openned_at: DateTime.utc_now()]})
  end

  defp close(circuit) do
    Logger.info("[#{__MODULE__}] Closing circuit #{circuit}")

    :ets.delete(Config.table_name(), circuit)
  end
end
