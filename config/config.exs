use Mix.Config

if Mix.env != :prod do
  config :mix_test_watch,
    extra_extensions: [".soup"]
end
