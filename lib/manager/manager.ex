defmodule Virgil.Manager do
  @moduledoc false

  @type circuit_name :: :atom

  @doc """
  Validates if the circuit is closed
  """
  @callback is_closed?(circuit_name()) :: {:ok, boolean()} | {:error, any()}

  @doc """
  Closes the circuit, it means the circuit will execute every time it is called
  """
  @callback close(circuit_name()) :: :ok | :error

  @doc """
  Opens the circuit, it will not execute until the counter was completely cleaned up and the manager opens it again
  """
  @callback open(circuit_name()) :: :ok | :error

  @doc """
  Increments the circuit error counter
  """
  @callback increment_error_counter(circuit_name()) :: {:ok, integer()} | {:error, any()}

  @doc """
  Decrements the circuit error counter
  """
  @callback decrement_error_counter(circuit_name()) :: {:ok, integer()} | {:error, any()}
end
