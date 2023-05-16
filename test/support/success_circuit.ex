defmodule Virgil.SuccessCircuit do
  use Virgil.Circuit,
    circuit_name: :success_circuit,
    error_threshold: 3

  def run, do: {:ok, %{}}
end
