defmodule Mixapp.MixProject do
  use Mix.Project

  def project do
    [
      app: :mixapp,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:poison, "~> 6.0"},
      {:httpoison, "~> 2.2"},
      {:floki, "~> 0.36"},
      {:ex_doc, "~> 0.34", only: :dev},
      {:plug, "~> 1.16"}
    ]
  end
end
