defmodule Simple.LessThan do
  keys = [:lhs, :rhs]
  @enforce_keys keys
  defstruct keys

  alias Simple.{Expression, True}

  @type t :: %__MODULE__{lhs: Expression.t,
                         rhs: Expression.t}

  @doc """
  Construct an size comparison node.
  """
  @spec new(Expression.t, Expression.t) :: t
  def new(lhs, rhs) do
    %__MODULE__{lhs: lhs, rhs: rhs}
  end
end

defimpl Simple.Expression, for: Simple.LessThan do

  def reduce(%{lhs: lhs, rhs: rhs}, env) do
    alias Simple.{LessThan, Expression, True, False}
    res =
      with {:lhs, :noop} <- {:lhs, Expression.reduce(lhs, env)},
           {:rhs, :noop} <- {:rhs, Expression.reduce(rhs, env)} do
        compare(lhs, rhs)
      else
        {:lhs, {:ok, lhs}} -> LessThan.new(lhs, rhs)
        {:rhs, {:ok, rhs}} -> LessThan.new(lhs, rhs)
      end
    {:ok, res}
  end

  defp compare(lhs, rhs) do
    alias Simple.{True, False}
    if lhs < rhs do
      True.new()
    else
      False.new()
    end
  end
end

defimpl Inspect, for: Simple.LessThan do

  def inspect(x, _opts) do
    "#{inspect x.lhs} < #{inspect x.rhs}"
  end
end
