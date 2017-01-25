defmodule Soup.Mixfile do
  use Mix.Project

  def project do
    [app: :soup,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: Soup.CLI],
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:mix_test_watch, "~> 0.2", only: [:dev, :test]},
     {:dialyxir, "~> 0.4", only: [:dev]}]
  end
end
