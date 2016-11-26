defmodule Simple.False do
  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Construct a false boolean node.

      iex> Simple.False.new()
      %Simple.False{}
  """
  @spec new() :: t
  def new do
    %__MODULE__{}
  end
end

defimpl Simple.Expression, for: Simple.False do

  def reduce(_, _) do
    :noop
  end
end

defimpl Inspect, for: Simple.False do

  def inspect(%{}, _opts) do
    "false"
  end
end
