defmodule Soup.FalseTest do
  use ExUnit.Case
  doctest Soup.AST.False

  alias Soup.{Env, AST}
  alias Soup.AST.False

  @env Env.new()

  describe "AST.reduce/2" do
    test "reduction of add of numbers" do
      expr = False.new()
      assert AST.reduce(expr, @env) == :noop
    end
  end

  describe "AST.to_source/2" do
    test "Add printing" do
      num = False.new()
      assert AST.to_source(num) == "false"
    end
  end
end
