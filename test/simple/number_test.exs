defmodule Simple.NumberTest do
  use ExUnit.Case
  doctest Simple.Number

  alias Simple.Number
  alias Simple.Expression
  alias Simple.Environment

  @env Environment.new()

  describe "Expression.reduce/1" do
    test "numbers are not reducible" do
      num = Number.new(64)
      assert Expression.reduce(num, @env) == :noop
    end
  end

  describe "Expression.to_source/1" do
    test "numbers printing" do
      num = Number.new(64)
      assert Expression.to_source(num) == "64"
    end
  end
end
