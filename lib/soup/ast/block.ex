defmodule Soup.AST.Block do
  @moduledoc """
  A block of multiple expressions.
  """

  keys = [:expressions]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{expressions: [AST.t]}

  @doc """
  Construct a Block node.

      iex> Soup.AST.Block.new([Soup.AST.Number.new(1)])
      %Soup.AST.Block{expressions: [Soup.AST.Number.new(1)]}
  """
  @spec new(number) :: t
  def new(exprs) when is_list(exprs) do
    %__MODULE__{expressions: exprs}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.Block do

  def reduce(%{expressions: [expr]}, env) do
    case Soup.AST.reduce(expr, env) do
      {:ok, new_expr, new_env} ->
        new_block = Soup.AST.Block.new([new_expr])
        {:ok, new_block, new_env}

      :noop ->
        {:ok, expr, env}
    end
  end

  def reduce(%{expressions: [expr|tail_exprs]}, env) do
    case Soup.AST.reduce(expr, env) do
      {:ok, new_expr, new_env} ->
        new_block = Soup.AST.Block.new([new_expr|tail_exprs])
        {:ok, new_block, new_env}

      :noop ->
        new_block = Soup.AST.Block.new(tail_exprs)
        {:ok, new_block, env}
    end
  end

  def to_source(%{expressions: expressions}, _opts) do
    expressions
    |> Enum.map(&Soup.AST.to_source/1)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
end
