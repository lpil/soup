defmodule Soup.AST.Return do
  @moduledoc """
  A marker for when a function returned. Used for stack manipulation.
  """

  alias Soup.AST

  keys = [:value]
  @enforce_keys keys
  defstruct keys

  @opaque t :: %__MODULE__{value: AST.t}

  @doc """
  Construct a Return node.

      iex> Soup.AST.Return.new(Soup.AST.Number.new(3))
      %Soup.AST.Return{value: Soup.AST.Number.new(3)}
  """
  @spec new(AST.t) :: t
  def new(value) when is_map(value) do
    %__MODULE__{value: value}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.Return do

  alias Soup.{AST, Env}

  def reduce(return, env) do
    case AST.reduce(return.value, env) do
      {:ok, new_value, env} ->
        new_ret = AST.Return.new(new_value)
        {:ok, new_ret, env}

      :noop ->
        {:ok, return.value, Env.pop_stack(env)}
    end
  end

  def to_source(%{value: value}, _opts) do
    Soup.AST.to_source(value)
  end
end
