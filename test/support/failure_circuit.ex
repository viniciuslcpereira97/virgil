defmodule CircuitBreaker.FailureCircuit do
  use CircuitBreaker.Circuit,
    circuit_name: :failure_circuit,
    error_threshold: 3

  def run, do: {:error, %{}}
end
