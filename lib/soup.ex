defmodule Soup do
  @moduledoc """
  A rather rubbish interpreted language.
  """

  alias Soup.{Source, Machine}

  @doc """
  Makes the magic happen.
  """
  def eval(source) when is_binary(source) do
    {:ok, machine} =
      source
      |> Source.parse!()
      |> Machine.new()
      |> Machine.run
    machine.ast
  end
end
