defmodule CircuitBreaker.ManagerClient do
  @moduledoc false

  @type circuit_name :: atom()

  @server_name :circuit_manager

  @spec closed?(circuit_name()) :: {:ok, any()} | {:error, any()}
  def closed?(circuit_name) do
    GenServer.call(@server_name, {:is_closed?, circuit_name})
  end

  @spec open(circuit_name()) :: {:ok, any()} | {:error, any()}
  def open(circuit_name) do
    GenServer.cast(@server_name, {:open, circuit_name})
  end

  @spec close(circuit_name()) :: {:ok, any()} | {:error, any()}
  def close(circuit_name) do
    GenServer.cast(@server_name, {:close, circuit_name})
  end
end
