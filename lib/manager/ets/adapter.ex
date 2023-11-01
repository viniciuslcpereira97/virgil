defmodule Virgil.Manager.Ets.Adapter do
  @moduledoc false

  @behaviour Virgil.Adapter

  alias Virgil.Circuit

  @impl true
  def is_closed?(%Circuit{name: circuit_name}),
    do: {:ok, GenServer.call(:ets_manager, {:is_closed?, circuit_name})}

  @impl true
  def close(%Circuit{name: circuit_name}),
    do: GenServer.cast(:ets_manager, {:close, circuit_name})

  @impl true
  def open(%Circuit{name: circuit_name}),
    do: GenServer.cast(:ets_manager, {:open, circuit_name})

  @impl true
  def increment_error_counter(%Circuit{name: circuit_name}),
    do: GenServer.call(:ets_manager, {:increment_counter, circuit_name})
end
