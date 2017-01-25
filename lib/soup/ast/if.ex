defmodule Soup.AST.If do
  keys = [:condition, :consequence, :alternative]
  @enforce_keys keys
  defstruct keys

  alias Soup.AST

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

defimpl Soup.AST.Protocol, for: Soup.AST.If do

  def to_source(x, _opts) do
    import Soup.AST, only: [to_source: 1]
    """
    if (#{to_source x.condition}) {
      #{to_source x.consequence}
    } else {
      #{to_source x.alternative}
    }
    """
  end

  def reduce(%{condition: %Soup.AST.False{}} = x, env) do
    {:ok, x.alternative, env}
  end
  def reduce(x, env) do
    case Soup.AST.reduce(x.condition, env) do
      :noop ->
        {:ok, x.consequence, env}
      {:ok, condition, new_env} ->
        new_if = Soup.AST.If.new(condition, x.consequence, x.alternative)
        {:ok, new_if, new_env}
    end
  end
end
