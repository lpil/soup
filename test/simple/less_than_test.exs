defmodule Simple.LessThanTest do
  use ExUnit.Case
  doctest Simple.LessThan

  alias Simple.{LessThan, True, False, Add, Number, Environment, Expression}

  @env Environment.new()

  describe "Simple.Reduce protocol" do
    test "numbers can be less than" do
      expr = LessThan.new(Number.new(1), Number.new(2))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert True.new() == res
    end

    test "numbers can be equal" do
      expr = LessThan.new(Number.new(1), Number.new(1))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert False.new() == res
    end

    test "numbers can be more than" do
      expr = LessThan.new(Number.new(2), Number.new(1))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert False.new() == res
    end

    test "lhs is reduced" do
      expr = LessThan.new(Add.new(Number.new(1), Number.new(1)), Number.new(1))
      assert {:ok, res} = Expression.reduce(expr, @env)
      assert LessThan.new(Number.new(2), Number.new(1)) == res
    end

    # test "rhs is reduced" do
    #   expr = LessThan.new(Number.new(1), Add.new(Number.new(1), Number.new(1)))
    #   assert {:ok, res} = Expression.reduce(expr, @env)
    #   assert LessThan.new(Number.new(2), Number.new(1)) == res
    # end
  end


  describe "Inspect protocol" do
    test "If printing" do
      expr = LessThan.new(Number.new(1), Number.new(2))
      assert inspect(expr) == "1 < 2"
    end
  end
end
