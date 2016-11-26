defmodule Simple do
end

defprotocol Simple.Expression do
  @type t :: any

  @spec reduce(t) :: {:ok, t} | :noop
  def reduce(data)
end
