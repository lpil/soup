defmodule Soup.Machine do

  alias Soup.{Env, AST}

  @type t :: %__MODULE__{ast: AST.t, env: Env.t}

  @enforce_keys [:ast]
  defstruct ast: nil,
            env: Env.new

  @doc """
  Construct a new Machine from a given AST.
  """
  def new(ast, env \\ Env.new) when is_map(ast) and is_map(env) do
    %__MODULE__{ast: ast, env: env}
  end


  @doc """
  Attempt to reduce the state of the machine by one step.
  """
  @spec step(t) :: {:ok, t} | :noop
  def step(%__MODULE__{ast: ast, env: env}) do
    case AST.reduce(ast, env) do
      {:ok, new_ast, new_env} -> {:ok, new(new_ast, new_env)}

      :noop -> :noop
    end
  end

  @doc """
  Reduce the state of the machine until it can be reduced no more.
  """
  @spec run(t) :: {:ok, t}
  def run(%__MODULE__{} = machine) do
    case step(machine) do
      :noop -> {:ok, machine}

      {:ok, new_machine} -> run(new_machine)
    end
  end
end

defimpl Inspect, for: Soup.Machine do
  def inspect(_, _) do
    "#Soup.Machine<AST, Env>"
  end
end
