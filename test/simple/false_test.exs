defmodule Simple.FalseTest do
  use ExUnit.Case
  doctest Simple.False

  alias Simple.False
  alias Simple.Environment
  alias Simple.Expression

  @env Environment.new()

  describe "Simple.Reduce protocol" do
    test "reduction of add of numbers" do
      expr = False.new()
      assert Expression.reduce(expr, @env) == :noop
    end
  end

  describe "Inspect protocol" do
    test "Add printing" do
      num = False.new()
      assert inspect(num) == "false"
    end
  end
end
