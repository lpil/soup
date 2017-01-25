defmodule SoupTest do
  use ExUnit.Case

  examples =
    [Application.app_dir(:soup), "priv", "code", "*.soup"]
    |> Path.join()
    |> Path.wildcard()

  for path <- examples do
    name = Path.basename(path)
    code = File.read!(path)

    @tag :integration
    test "eval-ing `priv/code/#{name}`" do
      assert Soup.eval(unquote(code))
    end
  end
end
