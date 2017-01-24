defmodule Simple.True do
  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Construct a true boolean node.

      iex> Simple.True.new()
      %Simple.True{}
  """
  @spec new() :: t
  def new do
    %__MODULE__{}
  end
end

defimpl Simple.Expression.Protocol, for: Simple.True do

  def reduce(_, _) do
    :noop
  end

  def to_source(%{}, _opts) do
    "true"
  end
end
