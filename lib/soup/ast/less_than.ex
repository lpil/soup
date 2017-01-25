defmodule Soup.AST.LessThan do
  keys = [:lhs, :rhs]
  @enforce_keys keys
  defstruct keys

  alias Soup.AST
  alias Soup.AST.True

  @type t :: %__MODULE__{lhs: AST.t,
                         rhs: AST.t}

  @doc """
  Construct an size comparison node.
  """
  @spec new(AST.t, AST.t) :: t
  def new(lhs, rhs) do
    %__MODULE__{lhs: lhs, rhs: rhs}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.LessThan do

  def to_source(x, _opts) do
    import Soup.AST, only: [to_source: 1]
    "#{to_source x.lhs} < #{to_source x.rhs}"
  end

  def reduce(%{lhs: lhs, rhs: rhs}, env) do
    alias Soup.AST
    alias Soup.AST.{LessThan, True, False}
    with {:lhs, :noop} <- {:lhs, AST.reduce(lhs, env)},
          {:rhs, :noop} <- {:rhs, AST.reduce(rhs, env)} do
      {:ok, compare(lhs, rhs), env}
    else
      {:lhs, {:ok, new_lhs, new_env}} -> {:ok, LessThan.new(new_lhs, rhs), new_env}
      {:rhs, {:ok, new_rhs, new_env}} -> {:ok, LessThan.new(lhs, new_rhs), new_env}
    end
  end

  defp compare(lhs, rhs) do
    alias Soup.AST.{True, False}
    if lhs < rhs do
      True.new()
    else
      False.new()
    end
  end
end
