defmodule Simple.AST do
  @type t :: any

  alias Simple.Env

  @spec reduce(t, Env.t) :: {:ok, t, Env.t} | :noop
  def reduce(ast, env) do
    case Simple.AST.Protocol.reduce(ast, env) do
      {:ok, _, %Env{}} = result ->
        result

      :noop ->
        :noop
    end
  end


  @spec to_source(t, any) :: String.t
  def to_source(expr, opts \\ %{}) do
    Simple.AST.Protocol.to_source(expr, opts)
  end
end

defprotocol Simple.AST.Protocol do
  alias Simple.{AST, Env}

  @spec reduce(AST.t, Env.t) :: {:ok, AST.t, Env.t} | :noop
  def reduce(data, env)

  @spec to_source(AST.t, any) :: String.t
  def to_source(expr, opts)
end
