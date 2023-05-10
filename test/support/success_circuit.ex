defmodule CircuitBreaker.SuccessCircuit do
  use CircuitBreaker.Circuit,
    circuit_name: :success_circuit,
    error_threshold: 3

  def run, do: {:ok, %{}}
end
