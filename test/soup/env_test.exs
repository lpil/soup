defmodule Soup.EnvTest do
  use ExUnit.Case, async: true
  doctest Soup.Env

  alias Soup.Env
  alias Soup.AST.Number

  describe "Env.put and Env.get" do
    test "putting and getting in the current scope" do
      env = Env.new
      assert :not_set == Env.get(env, :x)
      new_env = Env.put(env, :x, Number.new(4))
      assert {:ok, Number.new(4)} == Env.get(new_env, :x)
    end
  end

  describe "push_scope/1 and pop_scope/1" do
    test "grows and shrinks the stack with clean scopes" do
      env =
        Env.new
        |> Env.put(:x, Number.new(4))
        |> Env.push_scope()
      assert :not_set == Env.get(env, :x)
      new_env = Env.pop_scope(env)
      assert {:ok, Number.new(4)} == Env.get(new_env, :x)
    end
  end
end
