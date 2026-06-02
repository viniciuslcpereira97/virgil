defmodule Virgil.Manager.Logic.Circuit do
  @moduledoc false

  @spec threshold_reached?(integer(), integer()) :: boolean()
  def threshold_reached?(current_counter, error_threshold),
    do: current_counter >= error_threshold
end
