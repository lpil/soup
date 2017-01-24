defmodule Simple.AST.False do
  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Construct a false boolean node.

      iex> Simple.AST.False.new()
      %Simple.AST.False{}
  """
  @spec new() :: t
  def new do
    %__MODULE__{}
  end
end

defimpl Simple.AST.Protocol, for: Simple.AST.False do

  def reduce(_, _) do
    :noop
  end

  def to_source(%{}, _opts \\ nil) do
    "false"
  end
end
