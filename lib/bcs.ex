defmodule BCS do
  @moduledoc """
  BCS encoder in Elixir
  """

  @doc """
  Encode an Elixir value into BCS
  """
  defdelegate encode(value, type), to: BCS.Encode
end
