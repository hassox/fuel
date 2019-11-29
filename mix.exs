defmodule Fuel.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :fuel,
      version: @version,
      description: description(),
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        canonical: "https://hexdocs.pm/fuel",
        extras: ["README.md"],
        source_ref: "v#{@version}",
        source_url: "https://github.com/hassox/fuel"
      ],
      package: [
        files: [
          ".formatter.exs",
          "mix.exs",
          "README.md",
          "lib"
        ],
        licenses: ["MIT"],
        links: %{"Github" => "https://github.com/hassox/fuel"},
        maintainers: ["Daniel Neighman"]
      ],
      source_url: "https://github.com/hassox/fuel"
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
      {:ctx, "~> 0.5.0"},
      {:plug, ">= 1.8.0", optional: true},
      {:dialyxir, "~> 0.5.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Fuel provides some useful functionality to help build consistent applications
    """
  end
end
