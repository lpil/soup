defmodule Simple.IfTest do
  use ExUnit.Case
  doctest Simple.If

  alias Simple.{If, Add, True, False, Number, Environment, Expression}

  @env Environment.new()

  describe "Simple.Reduce protocol" do
    test "return consequence if condition is true" do
      expr = If.new(True.new(), Number.new(1), Number.new(2))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert Number.new(1) == res
    end

    test "return alternative if condition is false" do
      expr = If.new(False.new(), Number.new(1), Number.new(2))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert res == Number.new(2)
    end

    test "return alternative if condition is other non-false" do
      expr = If.new(Number.new(50), Number.new(10), Number.new(20))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert res == Number.new(10)
    end

    test "condition is reduced" do
      condition = Add.new(Number.new(5), Number.new(5))
      expr = If.new(condition, Number.new(10), Number.new(20))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert res == If.new(Number.new(10), Number.new(10), Number.new(20))
    end
  end

  describe "Inspect protocol" do
    test "If printing" do
      num = If.new(True.new(), Number.new(1), Number.new(2))
      assert inspect(num) == "if true { 1 } else { 2 }"
    end
  end
end
