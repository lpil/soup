defmodule Soup.EqTest do
  use ExUnit.Case
  doctest Soup.AST.Eq

  alias Soup.{AST, Env}
  alias Soup.AST.{Eq, Add, Number, True, False}

  @env Env.new()

  describe "AST.reduce/2" do
    test "reduction of Eq unequal" do
      expr = Eq.new(Number.new(1), Number.new(2))
      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == False.new
    end

    test "reduction of Eq equal" do
      expr = Eq.new(Number.new(2), Number.new(2))
      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == True.new
    end

    test "reduction of nested lhs" do
      expr = Eq.new(
        Add.new(Number.new(1), Number.new(2)),
        Number.new(3))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Eq.new(Number.new(3), Number.new(3))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == True.new
    end

    test "reduction of nested both side" do
      expr = Eq.new(
        Add.new(Number.new(1), Number.new(2)),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Eq.new(
        Number.new(3),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Eq.new(Number.new(3), Number.new(7))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == False.new
    end
  end

  describe "AST.to_source/2" do
    test "Eq printing" do
      num = Eq.new(Number.new(13), Number.new(0))
      assert AST.to_source(num) == "13 == 0"
    end
  end
end
