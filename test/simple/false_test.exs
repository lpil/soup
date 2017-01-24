defmodule Simple.FalseTest do
  use ExUnit.Case
  doctest Simple.False

  alias Simple.False
  alias Simple.Environment
  alias Simple.Expression

  @env Environment.new()

  describe "Expression.reduce/2" do
    test "reduction of add of numbers" do
      expr = False.new()
      assert Expression.reduce(expr, @env) == :noop
    end
  end

  describe "Expression.to_source/2" do
    test "Add printing" do
      num = False.new()
      assert Expression.to_source(num) == "false"
    end
  end
end
