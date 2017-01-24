defmodule Simple do
end

defmodule Simple.Environment do
  @type vars :: %{optional(atom) => any}
  @type t :: %__MODULE__{vars: vars}

  defstruct vars: []

  def new do
    %__MODULE__{}
  end
end


defprotocol Simple.Expression.Protocol do
  alias Simple.{Expression, Environment}

  @spec reduce(Expression.t, Environment.t) :: {:ok, t} | :noop
  def reduce(data, env)

  @spec to_source(Expression.t, any) :: String.t
  def to_source(expr, opts)
end


defmodule Simple.Expression do
  @type t :: any

  alias Simple.Environment

  @spec reduce(t, Environment.t) :: {:ok, t} | :noop
  defdelegate reduce(expr, env), to: Simple.Expression.Protocol


  @spec to_source(t, any) :: String.t
  def to_source(expr, opts \\ %{}) do
    Simple.Expression.Protocol.to_source(expr, opts)
  end
end
