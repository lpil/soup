defmodule Soup.CallTest do
  use ExUnit.Case
  doctest Soup.AST.Call

  alias Soup.{Env, AST}
  alias Soup.AST.{Call, Add, Number}

  @env Env.new

  describe "AST.reduce/2" do
    test "it throws on unset function" do
      env = Env.new
      ast = Call.new(:size, [])
      thrown = catch_throw(AST.reduce(ast, env))
      assert thrown == {:undefined_function, :size}
    end

    test "reduces arguments" do
      ast = Call.new(:width, [Add.new(Number.new(1), Number.new(2))])
      assert {:ok, res, @env} = AST.reduce(ast, @env)
      assert res == Call.new(:width, [Number.new(3)])
    end

    test "reduces multiple arguments" do
      ast = Call.new(:width, [Add.new(Number.new(1), Number.new(2)),
                              Add.new(Number.new(5), Number.new(2))])
      assert {:ok, res1, @env} = AST.reduce(ast, @env)
      assert res1 == Call.new(:width, [Number.new(3),
                                       Add.new(Number.new(5), Number.new(2))])
      assert {:ok, res2, @env} = AST.reduce(res1, @env)
      assert res2 == Call.new(:width, [Number.new(3), Number.new(7)])
    end

    @tag :skip
    test "it reduces to the body with new scope with args set"
  end

  describe "AST.to_source" do
    test "Call printing" do
      call = Call.new(:print, [Number.new(2)])
      assert AST.to_source(call) == "print(2)"
    end

    test "multi-arity call printing" do
      call = Call.new(:merge, [Number.new(1), Number.new(2), Number.new(3)])
      assert AST.to_source(call) == "merge(1, 2, 3)"
    end
  end
end
