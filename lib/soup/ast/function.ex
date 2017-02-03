defmodule Soup.AST.Function do
  @moduledoc """
  A number.
  """

  alias Soup.AST

  keys = [:arguments, :body]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{arguments: [atom], body: AST.t}

  @doc """
  Construct a Function node.

      iex> Soup.AST.Function.new([:_], Soup.AST.Number.new(1))
      %Soup.AST.Function{arguments: [:_], body: Soup.AST.Number.new(1)}
  """
  @spec new([atom], AST.t) :: t
  def new(arguments, body) when is_list(arguments) and is_map(body) do
    %__MODULE__{arguments: arguments, body: body}
  end
end

defimpl Soup.AST.Protocol, for: Soup.AST.Function do

  def reduce(_, _) do
    :noop
  end

  def to_source(%{arguments: arguments, body: body}, _opts) do
    import Soup.AST, only: [to_source: 1]
    """
    |#{Enum.join(arguments, ", ")}| {
        #{to_source(body)}
    }
    """
  end
end
