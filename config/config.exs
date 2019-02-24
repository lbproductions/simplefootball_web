# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :simplefootball_web,
  ecto_repos: [SimplefootballWeb.Repo]

# Configures the endpoint
config :simplefootball_web, SimplefootballWebWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JFgodEfJjHnL99/AJNdQtmazyrAt40ZWOG7mfEpsKwlSVEuqNMb6ucR43ghOpu8+",
  render_errors: [view: SimplefootballWebWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SimplefootballWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
