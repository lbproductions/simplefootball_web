use Mix.Config

port = String.to_integer(System.get_env("PORT") || "8080")

config :simplefootball_web, SimplefootballWebWeb.Endpoint,
  http: [:inet6, port: port],
  url: [host: System.get_env("HOSTNAME"), port: port],
  cache_static_manifest: "priv/static/cache_manifest.json",
  root: ".",
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true

# Do not print debug messages in production
# config :logger, level: :info

config :simplefootball_web, SimplefootballWeb.Repo,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 10
