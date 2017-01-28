defmodule Soup.VariableTest do
  use ExUnit.Case
  doctest Soup.AST.Variable

  alias Soup.{Env, AST}
  alias Soup.AST.{Variable, Number}

  describe "AST.reduce/2" do
    test "reduces to the value under the name in the env" do
      env = Env.new |> Env.put(:size, Number.new(2))
      ast = Variable.new(:size)
      assert {:ok, res, ^env} = AST.reduce(ast, env)
      assert res == Number.new(2)
    end

    test "it throws on unset variable" do
      env = Env.new
      ast = Variable.new(:size)
      thrown = catch_throw(AST.reduce(ast, env))
      assert thrown == {:undefined_variable, :size}
    end
  end

  describe "AST.to_source" do
    test "Variable printing" do
      var = Variable.new(:x)
      assert AST.to_source(var) == "x"
    end
  end
end
