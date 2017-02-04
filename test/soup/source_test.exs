defmodule Soup.SourceTest do
  use ExUnit.Case, async: true
  doctest Soup.Source

  alias Soup.Source
  alias Soup.AST.{Block, Number, True, False, Add, Subtract, LessThan, If,
                  Let, Variable, Function, Call, Eq}
  import Source, only: [tokenize!: 1, parse!: 1]

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

    test "== tokenization" do
      assert [{:==, _}] = tokenize!("==")
    end

    test "= tokenization" do
      assert [{:=, _}] = tokenize!("=")
    end

    test "| tokenization" do
      assert [{:|, _}] = tokenize!("|")
    end

    test ", tokenization" do
      assert [{:",", _}] = tokenize!(",")
    end

    test "if else tokenization" do
      assert [{:if, _}, {:"(", _}, {:true, _}, {:")", _},
              {:"{", _}, {:number, _, 1}, {:"}", _},
              {:else, _},
              {:"{", _}, {:number, _, 2}, {:"}", _},
            ] = tokenize!("if (true) { 1 } else { 2 }")
    end

    test "let tokenization" do
      assert [{:let, _}] = tokenize!("let")
    end

    test "comment tokenization" do
      assert [{:let, _}] = tokenize!("let // 1 2 3")
      assert [{:let, _}] = tokenize!("let//")
    end
  end


  describe "parse/1" do
    test "number parsing" do
      assert parse!("1") == Block.new([Number.new(1)])
      assert parse!("007") == Block.new([Number.new(7)])
      assert parse!("38.44") == Block.new([Number.new(38.44)])
    end

    test "`true` parsing" do
      assert parse!("true") == Block.new([True.new()])
    end

    test "`false` parsing" do
      assert parse!("false") == Block.new([False.new()])
    end

    test "+ parsing" do
      assert parse!("1 + 2") == Block.new([Add.new(Number.new(1),
                                                   Number.new(2))])
      assert parse!("false + 6") == Block.new([Add.new(False.new(),
                                                       Number.new(6))])
    end

    test "- parsing" do
      assert parse!("8 - 3") == Block.new([Subtract.new(Number.new(8),
                                                        Number.new(3))])
    end

    test "== parsing" do
      assert parse!("1 == 2") == Block.new([Eq.new(Number.new(1),
                                                   Number.new(2))])
    end

    test "< parsing" do
      assert parse!("1 < 2") == Block.new([LessThan.new(Number.new(1),
                                                       Number.new(2))])
      assert parse!("1 + 1 < 2") ==
        Block.new([LessThan.new(Add.new(Number.new(1), Number.new(1)),
                                Number.new(2))])
    end

    test "if parsing" do
      assert parse!("if true { 1 } else { 2 }") ==
          Block.new([If.new(True.new,
                            Block.new([Number.new(1)]),
                            Block.new([Number.new(2)]))])
    end

    test "assignment" do
      assert parse!("let x = 10") == Block.new([Let.new(:x, Number.new(10))])
    end

    test "block parsing" do
      assert parse!("""
      let a = 10
      let b = 20
      let c = 30
      """) == Block.new([Let.new(:a, Number.new(10)),
                         Let.new(:b, Number.new(20)),
                         Let.new(:c, Number.new(30))])
    end

    test "function parsing" do
      assert parse!("|a| { a }") ==
        Block.new([Function.new([:a],
                                Block.new([Variable.new(:a)]))])
      assert parse!("""
      |a, b| {
          a + b
      }
      """) ==
        Block.new([Function.new([:a, :b],
                                Block.new([Add.new(Variable.new(:a),
                                                   Variable.new(:b))]))])
    end

    test "call parsing" do
      assert parse!("print(1)") ==
        Block.new([Call.new(:print, [Number.new(1)])])
    end
  end
end
