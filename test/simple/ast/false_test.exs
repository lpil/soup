defmodule Simple.FalseTest do
  use ExUnit.Case
  doctest Simple.AST.False

  alias Simple.{Env, AST}
  alias Simple.AST.False

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
