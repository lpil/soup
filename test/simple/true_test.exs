defmodule Simple.TrueTest do
  use ExUnit.Case
  doctest Simple.True

  alias Simple.True
  alias Simple.Environment
  alias Simple.Expression

  @env Environment.new()

  describe "Expression.reduce/2" do
    test "reduction of add of numbers" do
      expr = True.new()
      assert Expression.reduce(expr, @env) == :noop
    end
  end

  describe "Expression.to_source/2" do
    test "Add printing" do
      bool = True.new()
      assert Expression.to_source(bool) == "true"
    end
  end
end
