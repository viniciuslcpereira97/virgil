defmodule CircuitBreakerTest do
  use ExUnit.Case
  doctest CircuitBreaker

  test "execute circuit" do
    assert CircuitBreaker.hello() == :world
  end
end
