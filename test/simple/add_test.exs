defmodule Simple.AddTest do
  use ExUnit.Case
  doctest Simple.Add

  alias Simple.{Add, Number, Expression, Environment}

  @env Environment.new()

  describe "Expression.reduce/2" do
    test "reduction of add of numbers" do
      expr = Add.new(Number.new(1), Number.new(2))
      assert {:ok, expr} = Expression.reduce(expr, @env)
      assert expr == Number.new(3)
    end

    test "reduction of nested lhs" do
      expr = Add.new(
        Add.new(Number.new(1), Number.new(2)),
        Number.new(3))

      assert {:ok, expr} = Expression.reduce(expr, @env)
      assert expr == Add.new(Number.new(3), Number.new(3))

      assert {:ok, expr} = Expression.reduce(expr, @env)
      assert expr == Number.new(6)
    end

    test "reduction of nested both side" do
      expr = Add.new(
        Add.new(Number.new(1), Number.new(2)),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr} = Expression.reduce(expr, @env)
      assert expr == Add.new(
        Number.new(3),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr} = Expression.reduce(expr, @env)
      assert expr == Add.new(Number.new(3), Number.new(7))

      assert {:ok, expr} = Expression.reduce(expr, @env)
      assert expr == Number.new(10)
    end
  end

  describe "Expression.to_source/2" do
    test "Add printing" do
      num = Add.new(Number.new(13), Number.new(0))
      assert Expression.to_source(num) == "13 + 0"
    end
  end
end
