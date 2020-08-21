# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :event_manager, EventManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AO8dEmXI3jXAAGGhk59EcoL6KvbS/Fi551Z3i1k38Sw8mGNWjO+CReo2tJK3h4nm",
  render_errors: [view: EventManagerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: EventManager.PubSub,
  live_view: [signing_salt: "2l5KS3OY"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :event_manager, :dho_discord_url, System.get_env("DHO_DISCORD_WEBHOOK_URL")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
