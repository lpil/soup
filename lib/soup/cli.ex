defmodule Soup.CLI do
  @moduledoc """
  Command line interface to Soup.ex
  """

  def main([path]) do
    path
    |> File.read!()
    |> Soup.eval()
    |> IO.inspect()
  end

  def main(_) do
    IO.puts """
    USAGE: soup path/to/code.smp
    """
  end
end
