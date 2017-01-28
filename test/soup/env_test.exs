defmodule Soup.EnvTest do
  use ExUnit.Case, async: true
  doctest Soup.Env

  alias Soup.Env
  alias Soup.AST.Number

  describe "Env.set and Env.get" do
    test "setting and getting" do
      env = Env.new
      assert :not_set == Env.get(env, :x)
      new_env = Env.put(env, :x, Number.new(4))
      assert {:ok, Number.new(4)} == Env.get(new_env, :x)
    end
  end
end
