defmodule AtlasWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :atlas_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AtlasWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:hound, "~> 1.0", only: :test},
      {:poison, "~> 3.1"},
      {:plug_cowboy, "~> 2.0"},
      {:guardian, "~> 1.2"},
      {:oauth2, "~> 0.9"},
      {:scrivener_html, "~> 1.8"},
      {:atlas, in_umbrella: true},
      {:atlas_pubsub, in_umbrella: true},
      {:atlas_log, in_umbrella: true, only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test --exclude browser_test"],
      "test.browser": ["ecto.create --quiet", "ecto.migrate", "test --include browser_test"],
      "test.browser.ci": ["ecto.create --quiet", "ecto.migrate", "test --include browser_test --exclude uses_browser_alert_box"]
    ]
  end
end
