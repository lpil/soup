defmodule Soup.AST.Number do
  @moduledoc """
  A number.
  """

  keys = [:value]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{value: number}

  @doc """
  Construct a Number node.

      iex> Soup.AST.Number.new(64)
      %Soup.AST.Number{value: 64}
  """
  @spec new(number) :: t
  def new(n) when is_number(n) do
    %__MODULE__{value: n}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.Number do

  def reduce(_, _) do
    :noop
  end

  def to_source(%{value: value}, _opts) do
    to_string(value)
  end
end
