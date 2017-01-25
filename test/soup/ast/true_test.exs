defmodule Soup.TrueTest do
  use ExUnit.Case
  doctest Soup.AST.True

  alias Soup.{Env, AST}
  alias Soup.AST.True

  @env Env.new()

  describe "AST.reduce/2" do
    test "reduction of add of numbers" do
      expr = True.new()
      assert AST.reduce(expr, @env) == :noop
    end
  end

  describe "AST.to_source/2" do
    test "Add printing" do
      bool = True.new()
      assert AST.to_source(bool) == "true"
    end
  end
end
