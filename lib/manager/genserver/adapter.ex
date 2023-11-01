defmodule Virgil.Manager.Genserver.Adapter do
  @moduledoc false

  alias Virgil.Circuit

  @behaviour Virgil.Adapter

  @impl true
  def close(%Circuit{name: circuit_name}),
    do: GenServer.cast(circuit_name, :close)

  @impl true
  def open(%Circuit{name: circuit_name}),
    do: GenServer.cast(circuit_name, :open)

  @impl true
  def is_closed?(%Circuit{name: circuit_name}),
    do: GenServer.call(circuit_name, :is_closed?)

  @impl true
  def increment_error_counter(%Circuit{name: circuit_name}),
    do: GenServer.call(circuit_name, :increment_failures)
end
