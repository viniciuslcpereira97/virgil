defmodule Virgil do
  @moduledoc """
  # Virgil

  Virgil is an Elixir library designed to abstract and simplify the utilization of internal circuit breakers within applications. Its primary function is to act as a guardian, ensuring uninterrupted operation even in the face of recurrent errors.

  ## Overview

  In modern applications, errors during requests are inevitable. Recurrent errors, however, can lead to service degradation, impacting user experience. Virgil addresses this challenge by seamlessly integrating with circuit breakers, providing a robust solution to handle such situations.

  ## Circuit Breakers: A Brief Overview

  Circuit breakers are a mechanism designed to control requests to a service. Their primary purpose is to prevent overload and cascading failures. When a defined error threshold is exceeded, the circuit breaker "opens," preventing further requests for a specified time period.

  ## How Virgil Works

  Virgil monitors requests and error rates. When recurrent errors are detected, it takes action by opening the circuit, temporarily halting requests. Once the defined time period has elapsed, normal operation is resumed.

  ## Benefits

  - **Reliability:** Ensures consistent performance, even in the presence of recurrent errors.
  - **Simplicity:** Abstracts complex circuit breaker logic for ease of use.
  - **Efficiency:** Prevents unnecessary requests during error-prone periods.

  ## Use Cases

  - **Microservices Architectures:** Ensure service resilience in a distributed environment.
  - **High Traffic Scenarios:** Safeguard against overload and cascading failures.
  - **Integration with Unreliable APIs:** Maintain reliability in the face of unpredictable external services.
  """

  defmodule Config do
    @moduledoc false

    @type error_threshold :: integer()
    @type registered_circuits :: list()
    @type time_frame :: integer()
    @type seconds :: integer()

    @doc """
    Manager module to be used

    Current available modules:
      - Virgil.Manager.ETSManager
      - Virgil.Manager.GenserverManager
    """
    @spec circuit_manager :: module()
    def circuit_manager,
      do: Application.get_env(:virgil, :manager)

    @doc """
    All application registered circuits
    """
    @spec registered_circuits :: registered_circuits()
    def registered_circuits,
      do: Application.get_env(:virgil, :circuits)

    @doc """
    Default openned circuit reset timeout in seconds
    """
    @spec default_reset_timeout :: seconds()
    def default_reset_timeout, do: 60

    @doc """
    Defines how many executions the circuit may run before it opens
    """
    @spec default_error_threshold :: error_threshold()
    def default_error_threshold,
      do: 5

    @doc """
    Initial circuit state
    """
    @spec default_circuit_state :: atom()
    def default_circuit_state,
      do: :closed
  end
end
