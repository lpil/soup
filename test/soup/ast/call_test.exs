defmodule Soup.CallTest do
  use ExUnit.Case
  doctest Soup.AST.Call

  alias Soup.{Env, AST}
  alias Soup.AST.{Call, Return, Add, Number, Function, Variable}

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

    test "it reduces to the body with new scope with args set" do
      identity = Function.new([:x], Variable.new(:x))
      env = @env |> Env.put(:identity, identity) |> Env.put(:y, Number.new(50))
      call = Call.new(:identity, [Number.new(1)])
      assert {:ok, expanded, new_env} = AST.reduce(call, env)
      # The AST is that of the function body, wrapped in a Return
      assert expanded == Return.new(Variable.new(:x)) # TODO
      # A new scope is created with function and args set
      assert Env.get(new_env, :y) == :not_set
      assert Env.get(new_env, :x) == {:ok, Number.new(1)}
      assert Env.get(new_env, :identity) == {:ok, identity}
    end

    test "it throws when too many args" do
      identity = Function.new([:x], Variable.new(:x))
      env = @env |> Env.put(:identity, identity)
      call = Call.new(:identity, [Number.new(1), Number.new(2)])
      thrown = catch_throw(AST.reduce(call, env))
      assert thrown == {:invalid_arity, :identity}
    end

    test "it throws when too few args" do
      identity = Function.new([:x], Variable.new(:x))
      env = @env |> Env.put(:identity, identity)
      call = Call.new(:identity, [])
      thrown = catch_throw(AST.reduce(call, env))
      assert thrown == {:invalid_arity, :identity}
    end
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
