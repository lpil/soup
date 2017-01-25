defmodule Soup.AST.BlockTest do
  use ExUnit.Case, async: true
  doctest Soup.AST.Block

  alias Soup.{AST, Env}
  alias Soup.AST.{Block, Add, Number}

  @env Env.new()

  describe "AST.reduce/1" do
    test "the first expression is discarded if not reducible" do
      block = Block.new([Number.new(1), Number.new(2)])
      assert {:ok, next, @env} = AST.reduce(block, @env)
      assert next == Block.new([Number.new(2)])
    end

    test "the first expression is reduced if reducible" do
      block = Block.new([Add.new(Number.new(1), Number.new(2)),
                         Number.new(4)])
      assert {:ok, next, @env} = AST.reduce(block, @env)
      assert next == Block.new([Number.new(3), Number.new(4)])
    end

    test "reduces to last expression if it is not reducible" do
      block = Block.new([Number.new(1)])
      assert {:ok, next, @env} = AST.reduce(block, @env)
      assert next == Number.new(1)
    end
  end


  describe "AST.to_source/1" do
    test "numbers printing" do
      num = Block.new([Number.new(64), Number.new(128)])
      assert AST.to_source(num) == """
      64
      128
      """
    end
  end
end
