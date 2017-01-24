defmodule Simple.AST.If do
  keys = [:condition, :consequence, :alternative]
  @enforce_keys keys
  defstruct keys

  alias Simple.AST

  @type t :: %__MODULE__{condition: AST.t,
                         consequence: AST.t,
                         alternative: AST.t}

  @doc """
  Construct an if flow control node.
  """
  @spec new(AST.t, AST.t, AST.t) :: t
  def new(condition, consequence, alternative) do
    %__MODULE__{condition: condition,
                consequence: consequence,
                alternative: alternative}
  end
end

defimpl Simple.AST.Protocol, for: Simple.AST.If do

  def to_source(x, _opts) do
    import Simple.AST, only: [to_source: 1]
    """
    if (#{to_source x.condition}) {
      #{to_source x.consequence}
    } else {
      #{to_source x.alternative}
    }
    """
  end

  def reduce(%{condition: %Simple.AST.False{}} = x, env) do
    {:ok, x.alternative, env}
  end
  def reduce(x, env) do
    case Simple.AST.reduce(x.condition, env) do
      :noop ->
        {:ok, x.consequence, env}
      {:ok, condition, new_env} ->
        new_if = Simple.AST.If.new(condition, x.consequence, x.alternative)
        {:ok, new_if, new_env}
    end
  end
end
