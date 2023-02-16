defmodule BCS.Encode do
  @moduledoc """
  Utilities for encoding Elixir values into BCS.
  """

  import Bitwise
  import BCS.Util, only: [to_base: 2]

  alias BCS.DataType, as: T

  @spec encode(term, T.t()) :: binary()
  def encode(n, %T.UInt{bit_length: bit_length})
      when n < 1 <<< bit_length do
    <<n::little-unsigned-size(bit_length)>>
  end

  def encode(n, %T.Int{bit_length: bit_length})
      when n < 1 <<< (bit_length - 1) and
             n >= -(1 <<< (bit_length - 1)) do
    <<n::little-signed-size(bit_length)>>
  end

  def encode(value, %T.Str{}) do
    encode(value, T.Binary.t())
  end

  def encode(value, %T.Binary{byte_length: nil}) do
    uleb128(byte_size(value)) <> value
  end

  def encode(value, %T.Binary{byte_length: byte_length}) do
    n = byte_length * 8
    <<:binary.decode_unsigned(value)::size(n)>>
  end

  def encode(value, %T.Address{}) do
    encode(value, T.Binary.t(32))
  end

  def encode(true, %T.Bool{}), do: <<1>>
  def encode(false, %T.Bool{}), do: <<0>>

  def encode(xs, %T.List{inner: type}) when is_map(type) do
    uleb128(length(xs)) <> Enum.map_join(xs, &encode(&1, type))
  end

  def encode(xs, %T.List{inner: choices}) when is_list(choices) do
    uleb128(length(xs)) <> encode(xs, T.Tuple.t(choices))
  end

  def encode(_, %T.Unit{}), do: <<>>

  def encode(value, %T.Maybe{inner: type}) do
    List.wrap(value)
    |> encode(T.List.t(type))
  end

  def encode(xs, %T.Tuple{arrangement: types}) when is_list(xs) do
    xs
    |> Enum.zip_with(types, &encode/2)
    |> Enum.join()
  end

  def encode(xs, %T.Tuple{arrangement: types}) when is_tuple(xs) do
    Tuple.to_list(xs)
    |> encode(T.Tuple.t(types))
  end

  def encode(value, %T.Struct{layout: layout}) do
    Keyword.keys(layout)
    |> Enum.map(&Map.get(value, &1))
    |> encode(T.Tuple.t(Keyword.values(layout)))
  end

  def encode(value, %T.Map{key: k_type, value: v_type}) do
    uleb128(map_size(value)) <>
      (value
       |> Enum.map(&encode(Tuple.to_list(&1), T.Tuple.t({k_type, v_type})))
       |> Enum.sort()
       |> Enum.join())
  end

  def encode(value, %T.Choice{selection: type, index: i}) do
    uleb128(i) <> encode(value, type)
  end

  def encode(values, %T.DoubleEncode{arrangement: types}) do
    values
    |> Enum.zip_with(types, &encode/2)
    |> encode(T.List.t(T.Binary.t()))
  end

  # Helpers

  @spec uleb128(integer | Decimal.t()) :: binary
  def uleb128(n) when n >= 0 and is_integer(n) do
    case to_base(n, 128) do
      [] ->
        <<0>>

      [h | t] ->
        [h | Enum.map(t, &add_high_1_bit/1)]
        |> Enum.reverse()
        |> Enum.map_join(&<<&1::integer-unsigned-8>>)
    end
  end

  defp add_high_1_bit(n) do
    n ||| 1 <<< 7
  end
end
