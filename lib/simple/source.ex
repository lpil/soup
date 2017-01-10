defmodule Simple.Source do
  @moduledoc """
  Source code parsing and tokenization.
  """

  @type token :: {atom, any, any}

  @doc """
  Convert a string of source code into tokens.
  """
  @spec tokenize(String.t) :: {:ok, [token]} | {:error, number, tuple}
  def tokenize(source) when is_binary(source) do
      source
      |> String.to_charlist()
      |> :simple_tokenizer.string()
      |> case do
        {:ok, tokens, _} ->
          {:ok, tokens}

        {:error, {line, _, error}, _} ->
          {:error, line, error}
      end
  end
end
