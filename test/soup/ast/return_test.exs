defmodule Soup.ReturnTest do
  use ExUnit.Case
  doctest Soup.AST.Return

  alias Soup.{AST, Env}
  alias Soup.AST.{Return, Number, Add}

  @env Env.new

  describe "AST.reduce/1" do
    test "it reduces the body" do
      return = Return.new(Add.new(Number.new(10), Number.new(10)))
      assert {:ok, result, @env} = AST.reduce(return, @env)
      assert Return.new(Number.new(20)) == result
    end

    test "it pops the stack as it reduces" do
      env = Env.new |> Env.push_stack()
      return = Return.new(Number.new(10))
      assert Env.stack_size(env) == 2
      assert {:ok, result, new_env} = AST.reduce(return, env)
      assert Number.new(10) == result
      assert Env.stack_size(new_env) == 1
    end
  end

  describe "AST.to_source/1" do
    test "returns are invisible!" do
      num = Return.new(Number.new(64))
      assert AST.to_source(num) == "64"
    end
  end
end
