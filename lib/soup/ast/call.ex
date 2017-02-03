defmodule Soup.AST.Call do
  @moduledoc """
  Value assignment.
  """

  alias Soup.AST

  keys = [:function, :arguments]
  @enforce_keys keys
  defstruct keys

  @type t :: %__MODULE__{function: atom, arguments: AST.t}

  @doc """
  Construct a function call node.

      iex> Soup.AST.Call.new(:print, [Soup.AST.Number.new(50)])
      %Soup.AST.Call{function: :print, arguments: [Soup.AST.Number.new(50)]}
  """
  @spec new(atom, [AST.t]) :: t
  def new(function, arguments)
    when is_atom(function) and is_list(arguments)
  do
    %__MODULE__{function: function, arguments: arguments}
  end
end


defimpl Soup.AST.Protocol, for: Soup.AST.Call do
  alias Soup.{AST, Env}

  def reduce(call, env) do
    with :noop <- reduce_arguments(call.arguments, env),
         {:ok, function} <- Env.get(env, call.function)
    do
      :ok
    else
      :not_set ->
        throw {:undefined_function, call.function}

      {:arg_reduced, new_args, new_env} ->
        {:ok, %{call | arguments: new_args}, new_env}
    end
  end

  defp reduce_arguments(args, env) when is_list(args) do
    cannot_reduce = fn(x) -> AST.reduce(x, env) == :noop end
    {noops, reducibles} = Enum.split_while(args, cannot_reduce)
    case reducibles do
      [] ->
        :noop

      [next|rest] ->
        {:ok, reduced, new_env} = AST.reduce(next, env)
        new_args = noops ++ [reduced|rest]
        {:arg_reduced, new_args, new_env}
    end
  end

  def to_source(%{function: function, arguments: arguments}, _opts) do
    args = arguments |> Enum.map(&Soup.AST.to_source/1) |> Enum.join(", ")
    "#{function}(#{args})"
  end
end
