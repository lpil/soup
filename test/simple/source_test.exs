defmodule Simple.SourceTest do
  use ExUnit.Case, async: true
  doctest Simple.Source

  alias Simple.{Number, True, False, Add, LessThan, If}

  defp tokenize!(source) do
    {:ok, source} = Simple.Source.tokenize(source)
    source
  end

  defp parse!(source) do
    {:ok, ast} = Simple.Source.parse(source)
    ast
  end

  describe "tokenize/1" do
    test "number tokenization" do
      assert [{:number, _, 1}] = tokenize!("1")
      assert [{:number, _, 1.1}] = tokenize!("1.1")
      assert [{:number, _, 29.12}] = tokenize!("29.12")
      assert [{:number, _, 7}] = tokenize!("0007")
    end

    test "atom (identifier) tokenization" do
      assert [{:atom, _, :hi}] = tokenize!("\n\nhi")
      assert [{:atom, _, :ok?}] = tokenize!("ok?")
      assert [{:atom, _, :do_exec!}] = tokenize!("do_exec!")
    end

    test "parens tokenization" do
      assert [{:"(", _}] = tokenize!("(")
      assert [{:")", _}] = tokenize!(")")
      assert [{:"(", _}, {:number, _, 1}, {:")", _}] = tokenize!("(1)")
    end

    test "brace tokenization" do
      assert [{:"{", _}] = tokenize!("{")
      assert [{:"}", _}] = tokenize!("}")
      assert [{:"{", _}, {:number, _, 1}, {:"}", _}] = tokenize!("{1}")
    end

    test "`true` tokenization" do
      assert [{:true, _}] = tokenize!("true")
    end

    test "`false` tokenization" do
      assert [{:false, _}] = tokenize!("false")
    end

    test "+ tokenization" do
      assert [{:+, _}] = tokenize!("+")
    end

    test "- tokenization" do
      assert [{:-, _}] = tokenize!("-")
    end

    test "< tokenization" do
      assert [{:<, _}] = tokenize!("<")
    end

    test "if else tokenization" do
      assert [{:if, _}, {:"(", _}, {:true, _}, {:")", _},
              {:"{", _}, {:number, _, 1}, {:"}", _},
              {:else, _},
              {:"{", _}, {:number, _, 2}, {:"}", _},
            ] = tokenize!("if (true) { 1 } else { 2 }")
    end
  end


  describe "parse/1" do
    test "number parsing" do
      assert parse!("1") == [Number.new(1)]
      assert parse!("007") == [Number.new(7)]
      assert parse!("38.44") == [Number.new(38.44)]
    end

    test "`true` parsing" do
      assert parse!("true") == [True.new()]
    end

    test "`false` parsing" do
      assert parse!("false") == [False.new()]
    end

    test "+ parsing" do
      assert parse!("1 + 2") == [Add.new(Number.new(1), Number.new(2))]
      assert parse!("false + 6") == [Add.new(False.new(), Number.new(6))]
    end

    # TODO
    # test "- parsing" do
    #   assert parse!("8 - 3") == [Subtract.new(Number.new(1), Number.new(1))]
    # end

    test "< parsing" do
      assert parse!("1 < 2") == [LessThan.new(Number.new(1), Number.new(2))]
      assert parse!("1 + 1 < 2") ==
        [LessThan.new(Add.new(Number.new(1), Number.new(1)),
                      Number.new(2))]
    end

    test "if parsing" do
      assert parse!("if (true) { 1 } else { 2 }") ==
          [If.new(True.new, Number.new(1), Number.new(2))]
    end
  end
end
