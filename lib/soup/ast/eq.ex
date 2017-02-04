defmodule Soup.AST.Eq do
  @moduledoc """
  Equality comparison.
  """

  alias Soup.AST

  keys = [:lhs, :rhs]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{lhs: AST.t, rhs: AST.t}

  @doc """
  Construct an Eq node.

  ...> Soup.Eq.new(Soup.Number.new(1), Soup.Number.new(2))
  %Soup.Eq{lhs: Number.new(1), rhs: Number.new(2)}
  """
  @spec new(struct, struct) :: t
  def new(lhs, rhs) when is_map(lhs) and is_map(rhs) do
    %__MODULE__{lhs: lhs, rhs: rhs}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.Eq do
  alias Soup.AST
  alias Soup.AST.{Eq, True, False}

  def to_source(%{lhs: lhs, rhs: rhs}, _opts) do
    "#{AST.to_source lhs} == #{AST.to_source rhs}"
  end

  def reduce(%{lhs: lhs, rhs: rhs}, env) do
    with {:lhs, :noop} <- {:lhs, AST.reduce(lhs, env)},
         {:rhs, :noop} <- {:rhs, AST.reduce(rhs, env)} do
      bool = if lhs.value == rhs.value do
        True.new
      else
        False.new
      end
      {:ok, bool, env}
    else
      {:lhs, {:ok, new_lhs, new_env}} ->
        {:ok, Eq.new(new_lhs, rhs), new_env}

      {:rhs, {:ok, new_rhs, new_env}} ->
        {:ok, Eq.new(lhs, new_rhs), new_env}
    end
  end
end
