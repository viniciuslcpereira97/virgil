defmodule CircuitBreaker.Behaviour do
  @type circuit_name :: atom() | String.t()

  @callback circuit_name :: atom()

  @callback error_threshold :: integer()
end
