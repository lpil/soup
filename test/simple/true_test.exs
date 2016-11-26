defmodule Simple.TrueTest do
  use ExUnit.Case
  doctest Simple.True

  alias Simple.True
  alias Simple.Environment
  alias Simple.Expression

  @env Environment.new()

  describe "Simple.Reduce protocol" do
    test "reduction of add of numbers" do
      expr = True.new()
      assert Expression.reduce(expr, @env) == :noop
    end
  end

  describe "Inspect protocol" do
    test "Add printing" do
      num = True.new()
      assert inspect(num) == "true"
    end
  end
end
