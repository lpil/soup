defmodule Simple.NumberTest do
  use ExUnit.Case
  doctest Simple.Number

  alias Simple.Number
  alias Simple.Expression

  describe "Simple.Reduce protocol" do
    test "numbers are not reducible" do
      num = Number.new(64)
      assert Expression.reduce(num) == :noop
    end
  end

  describe "Inspect protocol" do
    test "numbers printing" do
      num = Number.new(64)
      assert inspect(num) == "<<64>>"
    end
  end
end
