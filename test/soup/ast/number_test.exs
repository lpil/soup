defmodule Soup.NumberTest do
  use ExUnit.Case
  doctest Soup.AST.Number

  alias Soup.{AST, Env}
  alias Soup.AST.Number

  @env Env.new()

  describe "AST.reduce/1" do
    test "numbers are not reducible" do
      num = Number.new(64)
      assert AST.reduce(num, @env) == :noop
    end
  end

  describe "AST.to_source/1" do
    test "numbers printing" do
      num = Number.new(64)
      assert AST.to_source(num) == "64"
    end
  end
end
