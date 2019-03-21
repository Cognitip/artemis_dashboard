use Mix.Config

config :artemis,
  ecto_repos: [Artemis.Repo],
  root_user: %{
    name: System.get_env("ARTEMIS_ROOT_USER"),
    email: System.get_env("ARTEMIS_ROOT_EMAIL")
  },
  system_user: %{
    name: System.get_env("ARTEMIS_SYSTEM_USER"),
    email: System.get_env("ARTEMIS_SYSTEM_EMAIL")
  }

config :slugger, separator_char: ?-
config :slugger, replacement_file: "lib/replacements.exs"

import_config "#{Mix.env()}.exs"
