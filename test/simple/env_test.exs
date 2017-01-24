defmodule Simple.EnvTest do
  use ExUnit.Case, async: true
  doctest Simple.Env

  alias Simple.Env
  alias Simple.AST.Number

  describe "Env.set and Env.get" do
    test "setting and getting" do
      env = Env.new
      assert :not_set == Env.get(env, :x)
      new_env = Env.set(env, :x, Number.new(4))
      assert {:ok, Number.new(4)} == Env.get(new_env, :x)
    end
  end
end
