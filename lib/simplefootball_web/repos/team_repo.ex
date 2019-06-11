defmodule SimplefootballWeb.TeamRepo do
  import Ecto.{Query, Changeset}, warn: false

  alias SimplefootballWeb.{Repo, Team}

  require Logger

  def team_by_tm_identifier(tm_identifier) do
    Team
    |> Repo.get_by(tm_identifier: tm_identifier)
  end

  def update_or_create_team_by_tm_identifier(tm_identifier, changeset) do
    case team_by_tm_identifier(tm_identifier) do
      nil -> %Team{tm_identifier: tm_identifier}
      match -> match
    end
    |> Team.changeset(changeset)
    |> Repo.insert_or_update()
  end
end
