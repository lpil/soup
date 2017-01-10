defmodule Simple.SourceTest do
  use ExUnit.Case, async: true
  alias Simple.Source
  doctest Source

  def tokenize(source) do
    {:ok, source} = Source.tokenize(source)
    source
  end

  describe "tokenize/1" do
    test "number parsing" do
      assert [{:number, _, 1}] = tokenize("1")
      assert [{:number, _, 1.1}] = tokenize("1.1")
      assert [{:number, _, 29.12}] = tokenize("29.12")
      assert [{:number, _, 7}] = tokenize("0007")
    end

    test "atom (identifier) parsing" do
      assert [{:atom, _, :hi}] = tokenize("\n\nhi")
      assert [{:atom, _, :ok?}] = tokenize("ok?")
      assert [{:atom, _, :do_exec!}] = tokenize("do_exec!")
    end

    test "parens parsing" do
      assert [{:"(", _}] = tokenize("(")
      assert [{:")", _}] = tokenize(")")
      assert [{:"(", _}, {:number, _, 1}, {:")", _}] = tokenize("(1)")
    end
  end
end
