# ExBCS

[BCS](https://github.com/diem/bcs) encoder in Elixir.

Decoder is still WIP.


## Installation

The package can be installed by adding `ex_bcs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bcs, "~> 0.1.0", hex: :ex_bcs}
  ]
end
```

Documentation can be found at <https://hexdocs.pm/ex_bcs>.


## Usage

Use data types in the `BCS.DataType` module to declare the data types.

It is recommended to `alias BCS.DataType, as: T` for convenience.

For example:

```elixir
alias BCS.DataType, as: T

# Encode 100 as an uint8
BCS.encode(100, T.UInt.t(8))

# Encoode 314159 as an uint64
BCS.encode(314159, T.UInt.t(64))

# Encode "Hello world" as a string
BCS.encode("Hello world", T.Str.t())

# Encode {2, True, "too true"} as a tuple containing an uint64, a boolean, and a string
BCS.encode({2, True, "too true"}, T.Tuple.t([T.UInt.t(64), T.Bool.t(), T.Str.t()])

# Encode a struct
data = %{name: "Tom", age: 17}
layout = [name: T.Str.t(), age: T.UInt.t(8)]

BCS.encode(data, T.Struct.t(layout))

# Encode a choice type by specifying the variant index and the inner type
BCS.encode(%Result.Ok{value: 100_000}, T.Choice.t(T.UInt.t(64), 0))
BCS.encode(%Result.Err{value: "forbidden"}, T.Choice.t(T.Str.t(), 1))

```