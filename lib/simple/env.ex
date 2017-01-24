defmodule Simple.Env do
  @type vars :: %{optional(atom) => any}
  @type t :: %__MODULE__{vars: vars}

  defstruct vars: []

  def new do
    %__MODULE__{}
  end
end
