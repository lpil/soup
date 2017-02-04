defmodule Soup.Env do
  @typep scope :: %{optional(atom) => any}
  @opaque t :: %__MODULE__{stack: [scope]}

  defstruct stack: [%{}]


  @doc """
  Construct a new Env.

  """
  def new do
    %__MODULE__{}
  end


  @doc """
  Set a value in the current scope.

  """
  def put(%__MODULE__{} = env, name, value)
  when is_atom(name) and is_map(value) do
    [scope|scopes] = env.stack
    new_scope = Map.put(scope, name, value)
    %{env | stack: [new_scope|scopes]}
  end


  @doc """
  Get a value in the current scope.

  """
  def get(%__MODULE__{stack: [scope|_]}, name)
  when is_atom(name) do
    case Map.fetch(scope, name) do
      :error -> :not_set
      {:ok, _} = x -> x
    end
  end


  @doc """
  Push a fresh scope onto the stack

  """
  def push_stack(%__MODULE__{} = env) do
    %{env | stack: [%{}|env.stack]}
  end


  @doc """
  Pop the current scope off the stack

  """
  def pop_stack(%__MODULE__{} = env) do
    %{env | stack: tl(env.stack)}
  end

  @doc """
  Get the size of the stack.

      iex> Soup.Env.new() |> Soup.Env.push_stack() |> Soup.Env.stack_size()
      2
  """
  def stack_size(%__MODULE__{} = env) do
    length(env.stack)
  end
end
