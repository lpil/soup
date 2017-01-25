defmodule Soup.AST do
  @type t :: any

  alias Soup.Env

  @spec reduce(t, Env.t) :: {:ok, t, Env.t} | :noop
  def reduce(ast, env) do
    case Soup.AST.Protocol.reduce(ast, env) do
      {:ok, _, %Env{}} = result ->
        result

      :noop ->
        :noop
    end
  end

  @spec to_source(t, any) :: String.t
  def to_source(expr, opts \\ %{}) do
    Soup.AST.Protocol.to_source(expr, opts)
  end
end


defprotocol Soup.AST.Protocol do
  alias Soup.{AST, Env}

  @spec reduce(AST.t, Env.t) :: {:ok, AST.t, Env.t} | :noop
  def reduce(data, env)

  @spec to_source(AST.t, any) :: String.t
  def to_source(expr, opts)
end
