defmodule Soup.SubtractTest do
  use ExUnit.Case
  doctest Soup.AST.Subtract

  alias Soup.{AST, Env}
  alias Soup.AST.{Subtract, Number}

  @env Env.new()

  describe "AST.reduce/2" do
    test "reduction of add of numbers" do
      expr = Subtract.new(Number.new(5), Number.new(2))
      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Number.new(3)
    end

    test "reduction of nested lhs" do
      expr = Subtract.new(
        Subtract.new(Number.new(5), Number.new(2)),
        Number.new(1))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Subtract.new(Number.new(3), Number.new(1))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Number.new(2)
    end

    test "reduction of nested both side" do
      expr = Subtract.new(
        Subtract.new(Number.new(1), Number.new(2)),
        Subtract.new(Number.new(3), Number.new(4)))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Subtract.new(
        Number.new(-1),
        Subtract.new(Number.new(3), Number.new(4)))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Subtract.new(Number.new(-1), Number.new(-1))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Number.new(0)
    end
  end

  describe "AST.to_source/2" do
    test "Subtract printing" do
      num = Subtract.new(Number.new(13), Number.new(10))
      assert AST.to_source(num) == "13 - 10"
    end
  end
end
