defmodule BCS.Util do
  @moduledoc false

  # Base conversions for integers

  @spec to_base(integer, pos_integer) :: list(integer)
  def to_base(n, base) when is_integer(n) do
    do_to_base(abs(n), base, [])
  end

  defp do_to_base(n, base, acc) when is_integer(n) do
    if n > 0 do
      quotient = div(n, base)
      remainder = rem(n, base)
      do_to_base(quotient, base, [remainder | acc])
    else
      acc
    end
  end

  @spec from_base(list(integer), pos_integer) :: integer
  def from_base(xs, base) do
    Enum.reduce(xs, 0, fn x, acc -> acc * base + x end)
  end
end
