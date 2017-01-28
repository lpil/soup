defmodule Soup.AST.Let do
  @moduledoc """
  Value assignment.
  """

  keys = [:name, :value]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{name: atom, value: AST.t}

  @doc """
  Construct a Let node.

      iex> Soup.AST.Let.new(:x, Soup.AST.Number.new(64))
      %Soup.AST.Let{name: :x, value: Soup.AST.Number.new(64)}
  """
  @spec new(atom, AST.t) :: t
  def new(name, value) when is_atom(name) and is_map(value) do
    %__MODULE__{name: name, value: value}
  end
end


defimpl Soup.AST.Protocol, for: Soup.AST.Let do

  def reduce(%{name: name, value: value}, env) do
    alias Soup.AST
    case AST.reduce(value, env) do
      :noop ->
        new_env = Soup.Env.put(env, name, value)
        {:ok, value, new_env}

      {:ok, new_value, env} ->
        {:ok, AST.Let.new(name, new_value), env}
    end
  end

  def to_source(%{name: name, value: value}, _opts) do
    n = to_string(name)
    v = Soup.AST.to_source(value)
    "let #{n} = #{v}"
  end
end
