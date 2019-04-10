defmodule ExDuration.MixProject do
  use Mix.Project

  @version "0.1.2"
  @url "https://github.com/soundtrackyourbrand/exduration"

  def project do
    [
      app: :exduration,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "ExDuration",
      description: "Formatting function for durations",
      source_url: @url,
      docs: [
        main: "ExDuration",
        extras: ["README.md"]
      ]
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
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Petter Machado"],
      links: %{"GitHub" => @url}
    }
  end
end
