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

defprotocol Simple.Expression do
  alias Simple.Environment

  @type t :: any

  @spec reduce(t, Environment.t) :: {:ok, t} | :noop
  def reduce(data, env)
end
