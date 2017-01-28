defmodule Soup.AST.Variable do
  @moduledoc """
  Value assignment.
  """

  keys = [:name]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{name: atom}

  @doc """
  Construct a Let node.

      iex> Soup.AST.Variable.new(:x)
      %Soup.AST.Variable{name: :x}
  """
  @spec new(atom) :: t
  def new(name) when is_atom(name) do
    %__MODULE__{name: name}
  end
end


defimpl Soup.AST.Protocol, for: Soup.AST.Variable do

  def reduce(%{name: name}, env) do
    alias Soup.Env
    case Env.get(env, name) do
      :not_set -> throw {:undefined_variable, name}
      {:ok, v} -> {:ok, v, env}
    end
  end

  def to_source(%{name: name}, _opts) do
    to_string(name)
  end
end
