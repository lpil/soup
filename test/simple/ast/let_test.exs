defmodule Simple.LetTest do
  use ExUnit.Case
  doctest Simple.AST.Let

  alias Simple.{Env, AST}
  alias Simple.AST.{Let, Number, Add}

  @env Env.new()

  describe "AST.reduce/2" do
    test "reduces to the value" do
      ast = Let.new(:foo, Number.new(1))
      assert {:ok, res, _env} = AST.reduce(ast, @env)
      assert res == Number.new(1)
    end

    test "it sets the value in the environment" do
      ast = Let.new(:foo, Number.new(1))
      assert {:ok, _res, env} = AST.reduce(ast, @env)
      assert Env.get(env, :foo) == {:ok, Number.new(1)}
    end

    test "it reduces the value" do
      ast = Let.new(:thingy, Add.new(Number.new(1), Number.new(2)))
      assert {:ok, new_ast, @env} = AST.reduce(ast, @env)
      assert new_ast == Let.new(:thingy, Number.new(3))
    end
  end

  describe "AST.to_source" do
    test "Let printing" do
      let = Let.new(:x, Number.new(5))
      assert AST.to_source(let) == "let x = 5"
    end
  end
end
