defmodule Bcs.MixProject do
  use Mix.Project

  def project do
    [
      app: :bcs,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "ex_bcs",
      description: "BCS encoder in Elixir",
      package: package(),
      source_url: "https://github.com/Matthew8C/ex_bcs",
      docs: docs()
    ]
  end

  defp package do
    [
      name: "ex_bcs",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/Matthew8C/ex_bcs"},
      maintainers: ["Matthew A. C."]
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme"
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
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false}
    ]
  end
end
