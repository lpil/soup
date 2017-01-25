defmodule Soup.AddTest do
  use ExUnit.Case
  doctest Soup.AST.Add

  alias Soup.{AST, Env}
  alias Soup.AST.{Add, Number}

  @env Env.new()

  describe "AST.reduce/2" do
    test "reduction of add of numbers" do
      expr = Add.new(Number.new(1), Number.new(2))
      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Number.new(3)
    end

    test "reduction of nested lhs" do
      expr = Add.new(
        Add.new(Number.new(1), Number.new(2)),
        Number.new(3))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Add.new(Number.new(3), Number.new(3))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Number.new(6)
    end

    test "reduction of nested both side" do
      expr = Add.new(
        Add.new(Number.new(1), Number.new(2)),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Add.new(
        Number.new(3),
        Add.new(Number.new(3), Number.new(4)))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Add.new(Number.new(3), Number.new(7))

      assert {:ok, expr, @env} = AST.reduce(expr, @env)
      assert expr == Number.new(10)
    end
  end

  describe "AST.to_source/2" do
    test "Add printing" do
      num = Add.new(Number.new(13), Number.new(0))
      assert AST.to_source(num) == "13 + 0"
    end
  end
end
