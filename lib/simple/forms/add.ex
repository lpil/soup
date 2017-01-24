defmodule Simple.Add do
  @moduledoc """
  Number addition.
  """

  alias Simple.Expression

  keys = [:lhs, :rhs]
  @enforce_keys keys
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

defimpl Simple.Expression.Protocol, for: Simple.Add do

  def to_source(%{lhs: lhs, rhs: rhs}, _opts) do
    import Simple.Expression, only: [to_source: 1]
    "#{to_source lhs} + #{to_source rhs}"
  end

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
