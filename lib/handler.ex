defmodule Virgil.Handler do
  @moduledoc false

  def circuit_response({:ok, response}, circuit_module) do
    :telemetry.execute(
      [:virgil, :circuit, :success],
      %{circuit_response: response},
      %{
        circuit: circuit_module
      }
    )
  end

  def circuit_response({:error, response}, circuit_module) do
    :telemetry.execute(
      [:virgil, :circuit, :failure],
      %{circuit_response: response},
      %{
        circuit: circuit_module
      }
    )
  end
end
