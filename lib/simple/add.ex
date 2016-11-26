defmodule Simple.Add do
  @moduledoc """
  Number addition.
  """

  alias Simple.Expression

  keys = [:lhs, :rhs]
  @enforced_keys keys
  defstruct keys

  @type t :: %__MODULE__{lhs: Expression.t, rhs: Expression.t}

  @doc """
  Construct an Add node.

  ...> Simple.Add.new(Simple.Number.new(1), Simple.Number.new(2))
  %Simple.Add{lhs: Number.new(1), rhs: Number.new(2)}
  """
  @spec new(struct, struct) :: t
  def new(lhs, rhs) when is_map(lhs) and is_map(rhs) do
    %__MODULE__{lhs: lhs, rhs: rhs}
  end
end

defimpl Simple.Expression, for: Simple.Add do

  def reduce(%{lhs: lhs, rhs: rhs}, env) do
    alias Simple.{Add,Number,Expression}
    res =
      with {:lhs, :noop} <- {:lhs, Expression.reduce(lhs, env)},
           {:rhs, :noop} <- {:rhs, Expression.reduce(rhs, env)} do
        Number.new(lhs.value + rhs.value)
      else
        {:lhs, {:ok, lhs}} -> Add.new(lhs, rhs)
        {:rhs, {:ok, rhs}} -> Add.new(lhs, rhs)
      end
    {:ok, res}
  end
end

defimpl Inspect, for: Simple.Add do

  def inspect(%{lhs: lhs, rhs: rhs}, _opts) do
    "#{inspect lhs} + #{inspect rhs}"
  end
end
