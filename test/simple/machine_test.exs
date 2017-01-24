defmodule Simple.MachineTest do
  use ExUnit.Case, async: true
  doctest Simple.Machine

  alias Simple.{Machine, Env}
  alias Simple.AST.{Number, Add}

  describe "new/1" do
    test "machine construction" do
      machine = Machine.new(Number.new(5))
      assert machine.env == Env.new
      assert machine.ast == Number.new(5)
    end
  end

  describe "step/1" do
    test "AST is reduced once" do
      machine = Machine.new(Add.new(Number.new(5), Number.new(1)))
      assert {:ok, stepped} = Machine.step(machine)
      assert stepped.env == Env.new
      assert stepped.ast == Number.new(6)
    end

    test ":noop when AST cannot be reduced" do
      machine = Machine.new(Number.new(5))
      assert :noop == Machine.step(machine)
    end
  end

  describe "run/1" do
    test "AST is fully reduced" do
      add1 = fn(x) -> Add.new(x, Number.new(1)) end
      ast = add1.(add1.(add1.(add1.(add1.(Number.new(1))))))
      assert {:ok, machine} = ast |> Machine.new() |> Machine.run()
      assert machine.env == Env.new()
      assert machine.ast == Number.new(6)
    end
  end
end
