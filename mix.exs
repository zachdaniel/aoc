defmodule Aoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:spark, github: "ash-project/spark"},
      {:libgraph, "~> 0.16.0"},
      # File system event watcher
      {:file_system, "~> 0.2"}
    ]
  end

  defp aliases() do
    [
      watch: "aoc.watch",
      "spark.formatter": "spark.formatter --extensions Aoc.Day.Dsl"
    ]
  end
end
