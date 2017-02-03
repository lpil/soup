defmodule Soup.Env do
  @type scope :: %{optional(atom) => any}
  @type t :: %__MODULE__{scopes: [scope]}

  defstruct scopes: [%{}]


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
    [scope|scopes] = env.scopes
    new_scope = Map.put(scope, name, value)
    %{env | scopes: [new_scope|scopes]}
  end


  @doc """
  Get a value in the current scope.
  """
  def get(%__MODULE__{scopes: [scope|_]}, name)
  when is_atom(name) do
    case Map.fetch(scope, name) do
      :error -> :not_set
      {:ok, _} = x -> x
    end
  end


  @doc """
  Push a fresh scope onto the stack
  """
  def push_scope(%__MODULE__{} = env) do
    %{env | scopes: [%{}|env.scopes]}
  end


  @doc """
  Pop the current scope off the stack
  """
  def pop_scope(%__MODULE__{} = env) do
    %{env | scopes: tl(env.scopes)}
  end
end
