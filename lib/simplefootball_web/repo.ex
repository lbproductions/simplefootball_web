defmodule SimplefootballWeb.Repo do
  use Ecto.Repo,
    otp_app: :simplefootball_web,
    adapter: Ecto.Adapters.Postgres
end
