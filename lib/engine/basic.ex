defmodule CircuitBreaker.Engine.Basic do
  @moduledoc false

  alias CircuitBreaker.ManagerClient, as: CircuitManager

  def enqueue_circuit, do: nil

  def run_circuit(circuit) do
    opts = [circuit_name: circuit.circuit_name(), threshold: circuit.error_threshold()]

    circuit.run()
    |> handle_result(circuit, opts)
  end

  defp handle_result(result, circuit, _opts) do
    if circuit_fails?(result), do: CircuitManager.increase_error_counter(circuit.circuit_name())

    result
  end

  defp circuit_fails?(:error), do: true
  defp circuit_fails?({:error, _}), do: true
  defp circuit_fails?(_), do: false
end
