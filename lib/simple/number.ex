defmodule Simple.Number do
  @moduledoc """
  A number.
  """

  keys = [:value]
  @enforced_keys keys
  defstruct keys

  @type t :: %__MODULE__{value: number}

  @doc """
  Construct a Number node.

      iex> Simple.Number.new(64)
      %Simple.Number{value: 64}
  """
  @spec new(number) :: t
  def new(n) when is_number(n) do
    %__MODULE__{value: n}
  end
end

defimpl Simple.Expression, for: Simple.Number do

  def reduce(_) do
    :noop
  end
end

defimpl Inspect, for: Simple.Number do

  def inspect(%{value: value}, _opts) do
    "<<#{value}>>"
  end
end
