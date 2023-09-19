defmodule MyCircuit do
  use Virgil.Circuit,
    error_threshold: 3

  def run(_params) do
    IO.inspect("test")

    {:error, %{}}
  end
end
