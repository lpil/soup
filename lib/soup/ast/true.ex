defmodule Soup.AST.True do
  defstruct []

  @type t :: %__MODULE__{}

  @doc """
  Construct a true boolean node.

      iex> Soup.AST.True.new()
      %Soup.AST.True{}
  """
  @spec new() :: t
  def new do
    %__MODULE__{}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.True do

  def reduce(_, _) do
    :noop
  end

  def to_source(%{}, _opts) do
    "true"
  end
end
