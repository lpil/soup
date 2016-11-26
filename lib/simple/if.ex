defmodule Simple.If do
  keys = [:condition, :consequence, :alternative]
  @enforced_keys keys
  defstruct keys

  alias Simple.Expression

  @type t :: %__MODULE__{condition: Expression.t,
                         consequence: Expression.t,
                         alternative: Expression.t}

  @doc """
  Construct an if flow control node.
  """
  @spec new(Expression.t, Expression.t, Expression.t) :: t
  def new(condition, consequence, alternative) do
    %__MODULE__{condition: condition,
                consequence: consequence,
                alternative: alternative}
  end
end

defimpl Simple.Expression, for: Simple.If do

  def reduce(%{condition: %Simple.False{}} = x, _) do
    {:ok, x.alternative}
  end
  def reduce(x, env) do
    case Simple.Expression.reduce(x.condition, env) do
      :noop ->
        {:ok, x.consequence}
      {:ok, condition} ->
        {:ok, Simple.If.new(condition, x.consequence, x.alternative)}
    end
  end
end

defimpl Inspect, for: Simple.If do

  def inspect(x, _opts) do
    "if #{inspect x.condition} { #{inspect x.consequence} } else { #{inspect x.alternative} }"
  end
end
