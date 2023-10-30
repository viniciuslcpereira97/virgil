defmodule Virgil.Manager.Ets.Adapter do
  @moduledoc false

  @behaviour Virgil.Manager

  @impl true
  def is_closed?(circuit),
    do: {:ok, GenServer.call(:ets_manager, {:is_closed?, circuit})}

  @impl true
  def close(circuit),
    do: GenServer.cast(:ets_manager, {:close, circuit})

  @impl true
  def open(circuit),
    do: GenServer.cast(:ets_manager, {:open, circuit})

  @impl true
  def increment_error_counter(circuit),
    do: GenServer.call(:ets_manager, {:increment_counter, circuit})
end
