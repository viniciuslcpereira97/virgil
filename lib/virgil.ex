defmodule Virgil do
  @moduledoc """
  Virgil abstracts the use and managing application circuit breakers.
  """

  defmodule Config do
    @moduledoc false

    @type error_threshold :: integer()
    @type registered_circuits :: list()
    @type time_frame :: integer()
    @type table_visibility :: :public | :private

    def manager,
      do: Virgil.Manager.ETSManager

    @spec circuits_table_visibility :: table_visibility()
    def circuits_table_visibility,
      do: if(Mix.env() in [:dev, :test], do: :public, else: :private)

    @spec registered_circuits :: registered_circuits()
    def registered_circuits,
      do: Application.get_env(:virgil, :circuits)

    @spec default_time_frame :: time_frame()
    def default_time_frame,
      do: 5_000

    @spec default_error_threshold :: error_threshold()
    def default_error_threshold,
      do: 5

    @spec default_circuit_state :: atom()
    def default_circuit_state,
      do: :closed
  end
end
