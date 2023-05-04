defmodule TestCircuit do
  use CircuitBreaker.Circuit,
    error_threshold: 5,
    circuit_name: :my_awesome_circuit

  def run do
    {:ok, __MODULE__}
  end
end

defmodule Case do
  def test do
    Executor.execute(TestCircuit)
  end
end
