defmodule BCS.DataType do
  defmodule UInt do
    @moduledoc """
    Unsigned integers
    """

    defstruct bit_length: 64

    @type t() :: %__MODULE__{bit_length: pos_integer()}

    def t(bit_length \\ 64) when bit_length in [8, 16, 32, 64, 128, 256] do
      %__MODULE__{bit_length: bit_length}
    end
  end

  defmodule Int do
    @moduledoc """
    Signed integers
    """

    defstruct bit_length: 64

    @type t() :: %__MODULE__{bit_length: pos_integer()}

    def t(bit_length \\ 64) when bit_length in [8, 16, 32, 64, 128, 256] do
      %__MODULE__{bit_length: bit_length}
    end
  end

  defmodule Str do
    @moduledoc """
    Strings
    """

    defstruct []

    @type t() :: %__MODULE__{}

    def t(), do: struct(__MODULE__)
  end

  defmodule Binary do
    @moduledoc """
    Binary data
    which actually corresponds to a fixed or variable sequence of uint8 values
    """

    defstruct byte_length: nil

    @type t() :: %__MODULE__{byte_length: non_neg_integer() | nil}

    def t(), do: struct(__MODULE__)

    def t(byte_length) do
      struct(__MODULE__, byte_length: byte_length)
    end
  end

  defmodule Address do
    @moduledoc """
    Address data type
    Convenience type for dealing with the Aptos address type.
    Under the hood it is just the same as a fixed-length binary of 32 bytes.
    """

    defstruct []

    @type t :: %__MODULE__{}

    def t(), do: struct(__MODULE__)
  end

  defmodule Bool do
    @moduledoc """
    Booleans
    """

    defstruct []

    @type t() :: %__MODULE__{}

    def t(), do: struct(__MODULE__)
  end

  defmodule List do
    @moduledoc """
    Lists
    Represents a list of values of the same type.
    Corresponds to the `Sequence` type.
    """

    defstruct [:inner]

    @type t() :: %__MODULE__{inner: BCS.DataType.t() | list(BCS.DataType.Choice.t())}

    def t(inner_type) do
      struct(__MODULE__, inner: inner_type)
    end
  end

  defmodule Maybe do
    @moduledoc """
    The Maybe, or Optional type.
    """

    defstruct [:inner]

    @type t() :: %__MODULE__{inner: BCS.DataType.t()}

    def t(inner_type) do
      struct(__MODULE__, inner: inner_type)
    end
  end

  defmodule Tuple do
    @moduledoc """
    Tuples
    Arrays of values of potentially different types
    """

    defstruct [:arrangement]

    @type t() :: %__MODULE__{arrangement: list(BCS.DataType.t())}

    def t(arr) when is_list(arr) do
      struct(__MODULE__, arrangement: arr)
    end

    def t(arr) when is_tuple(arr) do
      struct(__MODULE__, arrangement: Elixir.Tuple.to_list(arr))
    end
  end

  defmodule Struct do
    @moduledoc """
    Structs
    """

    defstruct [:layout]

    @type t() :: %__MODULE__{layout: keyword(BCS.DataType.t())}

    def t(layout) when is_list(layout) do
      struct(__MODULE__, layout: layout)
    end
  end

  defmodule Map do
    @moduledoc """
    Mappings
    Under the hood, this data type represents values of variable-length, sorted sequences of (Key, Value) tuples.
    """

    defstruct [:key, :value]

    @type t() :: %__MODULE__{key: BCS.DataType.t(), value: BCS.DataType.t()}

    def t(k_type, v_type) do
      struct(__MODULE__, key: k_type, value: v_type)
    end
  end

  defmodule Hardcoded do
    @moduledoc """
    Hardcoded values
    """

    defstruct [:inner, :value]

    @type t() :: %__MODULE__{inner: BCS.DataType.t(), value: term()}

    def t(inner_type, value) do
      struct(__MODULE__, inner: inner_type, value: value)
    end
  end

  defmodule Choice do
    @moduledoc """
    The choice type, or the coproduct type, or the sum type, or the enum type, or whatever you want to name it.
    """

    defstruct [:selection, :index]

    @type t() :: %__MODULE__{
            selection: BCS.DataType.t(),
            index: non_neg_integer()
          }

    def t(selection, index) do
      struct(__MODULE__, selection: selection, index: index)
    end
  end

  defmodule DoubleEncode do
    @moduledoc """
    The double encoding type
    This type can be handy when sometimes somehow we need to BCS encode twice into a sequence of binaries.
    """

    defstruct [:arrangement]

    @type t() :: %__MODULE__{arrangement: list(BCS.DataType.t())}

    def t(arr) do
      struct(__MODULE__, arrangement: arr)
    end
  end

  @type t ::
          UInt.t()
          | Int.t()
          | Str.t()
          | Binary.t()
          | Address.t()
          | Bool.t()
          | List.t()
          | Maybe.t()
          | Tuple.t()
          | Struct.t()
          | Map.t()
          | Hardcoded.t()
          | Choice.t()
          | DoubleEncode.t()
end
