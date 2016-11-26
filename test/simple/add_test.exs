defmodule Simple.AddTest do
  use ExUnit.Case
  doctest Simple.Add

  alias Simple.Add
  alias Simple.Number
  alias Simple.Expression

  describe "Simple.Reduce protocol" do
    test "reduction of add of numbers" do
      expr = Add.new(Number.new(1), Number.new(2))
      assert {:ok, expr} = Expression.reduce(expr)
      assert expr == Number.new(3)
    end

    test "reduction of nested lhs" do
      expr = Add.new(
        Add.new(Number.new(1), Number.new(2)),
        Number.new(3))

      assert {:ok, expr} = Expression.reduce(expr)
      assert expr == Add.new(Number.new(3), Number.new(3))

      assert {:ok, expr} = Expression.reduce(expr)
      assert expr == Number.new(6)
    end

    test "reduction of nested both side" do
      expr = Add.new(
        Add.new(Number.new(1), Number.new(2)),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr} = Expression.reduce(expr)
      assert expr == Add.new(
        Number.new(3),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr} = Expression.reduce(expr)
      assert expr == Add.new(Number.new(3), Number.new(7))

      assert {:ok, expr} = Expression.reduce(expr)
      assert expr == Number.new(10)
    end
  end

  describe "Inspect protocol" do
    test "Add printing" do
      num = Add.new(Number.new(13), Number.new(0))
      assert inspect(num) == "<<13>> + <<0>>"
    end
  end
end
