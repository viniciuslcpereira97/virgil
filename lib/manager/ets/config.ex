defmodule Virgil.Manager.ETSManager.Config do
  @moduledoc false

  @type table_visibility :: :public | :private

  @spec circuits_table_visibility :: table_visibility()
  def circuits_table_visibility,
    do: if(Mix.env() in [:dev, :test], do: :public, else: :private)
end
