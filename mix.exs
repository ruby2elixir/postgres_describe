defmodule PostgresDescribe.Mixfile do
  use Mix.Project

  @app     :postgres_describe
  @name    "PostgresDescribe"
  @version "0.1.0"
  @github  "https://github.com/brandonparsons/#{@app}"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),

      # ExDoc
      name: @name,
      source_url: @github,
      homepage_url: @github,
      docs: [
        main: @name,
        canonical: "https://hexdocs.pm/#{@app}",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Library for describing postgres tables and saving that output into a given
    location in your application source.
    """
  end

  defp package do
    [
      name: @app,
      maintainers: ["Brandon Parsons"],
      licenses: ["MIT"],
      files: ~w(mix.exs lib README* LICENSE*),
      links: %{"Github" => @github}
    ]
  end

  defp deps do
    [
      {:cortex, "~> 0.3", only: [:dev, :test]},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:private, "~> 0.1.1", only: [:dev, :test]}
    ]
  end
end
