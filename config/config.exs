# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :reddit,
  ecto_repos: [Reddit.Repo]

# Configures the endpoint
config :reddit, RedditWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nF9lcI/ldeKPv3kVRFZ0+EjFeKcubYsA5mGNzoIG9NBLaL8EoFbek01bH/PiDh/z",
  render_errors: [view: RedditWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Reddit.PubSub,
  live_view: [signing_salt: "6D/JVeRb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :reddit, :pow,
  user: Reddit.Users.User,
  repo: Reddit.Repo,
  web_module: RedditWeb,
  extensions: [PowResetPassword, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  messages_backend: RedditWeb.Pow.Messages,
  mailer_backend: Reddit.Pow.Mailer,
  web_mailer_module: RedditWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
