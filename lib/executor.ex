defmodule Executor do

  @type circuit :: CircuitBreaker.Circuit.t()

  @spec execute(circuit()) :: any()
  def execute(circuit) do
    circuit.run()
    |> handle_result()
    |> send_telemetry_event()
  end

  defp handle_result(result) do
    case result do
      {:ok, _} -> :success
      {:error, _} -> :failure
    end
  end

  defp send_telemetry_event(:success) do
    :telemetry.execute([:circuit_breaker, :circuit, :success], %{}, %{})
  end

  defp send_telemetry_event(:failure) do
    :telemetry.execute([:circuit_breaker, :circuit, :failure], %{}, %{})
  end
end
