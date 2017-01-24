defmodule Simple do
  @moduledoc """
  A rather rubbish interpreted language.
  """

  alias Simple.{Source, Machine}

  @doc """
  Makes the magic happen.
  """
  def eval(source) when is_binary(source) do
    {:ok, machine} =
      source
      |> Source.parse!()
      |> hd               # TODO: Support blocks
      |> Machine.new()
      |> Machine.run
    machine.ast
  end
end
