defmodule Soup.AST.False do
  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Construct a false boolean node.

      iex> Soup.AST.False.new()
      %Soup.AST.False{}
  """
  @spec new() :: t
  def new do
    %__MODULE__{}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.False do

  def reduce(_, _) do
    :noop
  end

  def to_source(%{}, _opts \\ nil) do
    "false"
  end
end
