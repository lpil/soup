defmodule Simple.AST.Let do
  @moduledoc """
  Variable assignment.
  """

  keys = [:name, :value]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{name: atom, value: AST.t}

  @doc """
  Construct a Number node.

      iex> Simple.AST.Let.new(:x, Simple.AST.Number.new(64))
      %Simple.AST.Let{name: :x, value: Simple.AST.Number.new(64)}
  """
  @spec new(atom, AST.t) :: t
  def new(name, value) when is_atom(name) and is_map(value) do
    %__MODULE__{name: name, value: value}
  end
end


defimpl Simple.AST.Protocol, for: Simple.AST.Let do

  def reduce(%{name: name, value: value}, env) do
    alias Simple.AST
    case AST.reduce(value, env) do
      :noop ->
        new_env = Simple.Env.set(env, name, value)
        {:ok, value, new_env}

      {:ok, new_value, env} ->
        {:ok, AST.Let.new(name, new_value), env}
    end
  end

  def to_source(%{name: name, value: value}, _opts) do
    n = to_string(name)
    v = Simple.AST.to_source(value)
    "let #{n} = #{v}"
  end
end
