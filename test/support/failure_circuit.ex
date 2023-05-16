defmodule Virgil.FailureCircuit do
  use Virgil.Circuit,
    circuit_name: :failure_circuit,
    error_cooldown: 2_000,
    error_threshold: 3

  def run, do: {:error, %{}}
end
