defmodule BcsTest do
  use ExUnit.Case
  doctest Bcs

  test "greets the world" do
    assert Bcs.hello() == :world
  end
end
