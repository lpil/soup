defmodule Simple.AST.True do
  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Construct a true boolean node.

      iex> Simple.AST.True.new()
      %Simple.AST.True{}
  """
  @spec new() :: t
  def new do
    %__MODULE__{}
  end
end

defimpl Simple.AST.Protocol, for: Simple.AST.True do

  def reduce(_, _) do
    :noop
  end

  def to_source(%{}, _opts) do
    "true"
  end
end
