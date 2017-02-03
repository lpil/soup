defmodule Soup.AST.Subtract do
  @moduledoc """
  Number subtraction.
  """

  alias Soup.AST

  keys = [:lhs, :rhs]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{lhs: AST.t, rhs: AST.t}

  @doc """
  Construct an Subtract node.

  ...> Soup.Subtract.new(Soup.Number.new(1), Soup.Number.new(2))
  %Soup.Subtract{lhs: Number.new(1), rhs: Number.new(2)}
  """
  @spec new(struct, struct) :: t
  def new(lhs, rhs) when is_map(lhs) and is_map(rhs) do
    %__MODULE__{lhs: lhs, rhs: rhs}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.Subtract do

  def to_source(%{lhs: lhs, rhs: rhs}, _opts) do
    import Soup.AST, only: [to_source: 1]
    "#{to_source lhs} - #{to_source rhs}"
  end

  def reduce(%{lhs: lhs, rhs: rhs}, env) do
    alias Soup.AST
    alias Soup.AST.{Subtract, Number}
    with {:lhs, :noop} <- {:lhs, AST.reduce(lhs, env)},
         {:rhs, :noop} <- {:rhs, AST.reduce(rhs, env)} do
      new_num = Number.new(lhs.value - rhs.value)
      {:ok, new_num, env}
    else
      {:lhs, {:ok, new_lhs, new_env}} ->
        {:ok, Subtract.new(new_lhs, rhs), new_env}

      {:rhs, {:ok, new_rhs, new_env}} ->
        {:ok, Subtract.new(lhs, new_rhs), new_env}
    end
  end
end
