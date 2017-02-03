defmodule Soup.FunctionTest do
  use ExUnit.Case
  doctest Soup.AST.Function

  alias Soup.{Env, AST}
  alias Soup.AST.{Function, Variable}

  @env Env.new()

  describe "AST.reduce/2" do
    test "condition is reduced" do
      identity = Function.new([:a], Variable.new(:a))
      assert :noop == AST.reduce(identity, @env)
    end
  end

  describe "AST.to_source" do
    test "Function printing" do
      identity = Function.new([:a], Variable.new(:a))
      assert AST.to_source(identity) == """
      |a| {
          a
      }
      """
    end
  end
end
