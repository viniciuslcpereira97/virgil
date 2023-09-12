defmodule FakeCircuit do
  use Virgil.Circuit,
    error_threshold: 2

  def run(:success),
    do: {:ok, :test}

  def run(:failure),
    do: {:error, :test}
end

defmodule CircuitTest do
  use ExUnit.Case, async: true

  test "1" do
    # for _ <- 1..4, do: FakeCircuit.execute(:success)

    for _ <- 1..2, do: FakeCircuit.execute(:failure)
  end
end
