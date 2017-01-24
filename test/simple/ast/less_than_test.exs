defmodule Simple.LessThanTest do
  use ExUnit.Case
  doctest Simple.AST.LessThan

  alias Simple.{Env, AST}
  alias Simple.AST.{LessThan, True, False, Add, Number}

  @env Env.new()

  describe "Simple.AST.reduce" do
    test "numbers can be less than" do
      expr = LessThan.new(Number.new(1), Number.new(2))
      assert {:ok, res, @env} = AST.reduce(expr, @env)
      assert True.new() == res
    end

    test "numbers can be equal" do
      expr = LessThan.new(Number.new(1), Number.new(1))
      assert {:ok, res, @env} = AST.reduce(expr, @env)
      assert False.new() == res
    end

    test "numbers can be more than" do
      expr = LessThan.new(Number.new(2), Number.new(1))
      assert {:ok, res, @env} = AST.reduce(expr, @env)
      assert False.new() == res
    end

    test "lhs is reduced" do
      expr = LessThan.new(Add.new(Number.new(1), Number.new(1)), Number.new(1))
      assert {:ok, res, @env} = AST.reduce(expr, @env)
      assert LessThan.new(Number.new(2), Number.new(1)) == res
    end

    # test "rhs is reduced" do
    #   expr = LessThan.new(Number.new(1), Add.new(Number.new(1), Number.new(1)))
    #   assert {:ok, res} = AST.reduce(expr, @env)
    #   assert LessThan.new(Number.new(2), Number.new(1)) == res
    # end
  end


  describe "Simple.AST.to_source" do
    test "If printing" do
      expr = LessThan.new(Number.new(1), Number.new(2))
      assert AST.to_source(expr) == "1 < 2"
    end
  end
end
