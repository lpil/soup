defmodule Soup.Source do
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
      |> :soup_tokenizer.string()
      |> case do
        {:ok, tokens, _} ->
          {:ok, tokens}

        {:error, {line, _, error}, _} ->
          {:error, line, error}
      end
  end

  @doc """
  Convert a string of source code into tokens.

  Throws on syntax error.

  TODO: Better error messages.
  """
  @spec tokenize(String.t) :: [token]
  def tokenize!(source) do
    {:ok, source} = Soup.Source.tokenize(source)
    source
  end


  @doc """
  Converts a string of source code into an AST.
  """
  @spec tokenize(String.t) :: {:ok, AST.t}
  def parse(source) when is_binary(source) do
    case tokenize(source) do
      {:ok, tokens} ->
        :soup_parser.parse(tokens)

      {:error, _, _} = error ->
        error
    end
  end

  @doc """
  Converts a string of source code into an AST.

  Throws on syntax error.

  TODO: Better error messages.
  """
  def parse!(source) do
    {:ok, ast} = Soup.Source.parse(source)
    ast
  end
end
