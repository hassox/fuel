defmodule FuelTest do
  use ExUnit.Case
  doctest Fuel

  test "greets the world" do
    assert Fuel.hello() == :world
  end
end
