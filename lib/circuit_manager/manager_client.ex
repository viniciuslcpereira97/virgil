defmodule CircuitBreaker.ManagerClient do
  @moduledoc false

  @type circuit_name :: atom()

  @server_name :circuit_manager

  @spec is_closed?(circuit_name()) :: {:ok, any()} | {:error, any()}
  def is_closed?(circuit_name) do
    is_closed? = GenServer.call(@server_name, {:is_closed?, circuit_name})

    {:ok, is_closed?}
  end

  @spec open(circuit_name()) :: {:ok, any()} | {:error, any()}
  def open(circuit_name) do
    GenServer.cast(@server_name, {:open, circuit_name})
  end

  @spec close(circuit_name()) :: {:ok, any()} | {:error, any()}
  def close(circuit_name) do
    GenServer.cast(@server_name, {:close, circuit_name})
  end

  def increase_error_counter(circuit_name) do
    GenServer.call(@server_name, {:increase_error_counter, circuit_name})
  end

  def decrease_error_counter(circuit_name) do
    GenServer.call(@server_name, {:decrease_error_counter, circuit_name})
  end
end
