defmodule Simple.CLI do
  @moduledoc """
  Command line interface to Simple.ex
  """

  def main([path]) do
    path
    |> File.read!
    |> Simple.eval
  end

  def main(_) do
    IO.puts """
    USAGE: simple path/to/code.smp
    """
  end
end
