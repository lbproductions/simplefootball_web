defmodule SimplefootballWeb.MatchRepo do
  import Ecto.{Query, Changeset}, warn: false

  alias SimplefootballWeb.{Repo, Match}

  require Logger

  def match_by_tm_identifier(tm_identifier) do
    Match
    |> Repo.get_by(tm_identifier: tm_identifier)
  end

  def update_or_create_match_by_tm_identifier(tm_identifier, changeset) do
    case match_by_tm_identifier(tm_identifier) do
      nil -> %Match{tm_identifier: tm_identifier}
      match -> match
    end
    |> Match.changeset(changeset)
    |> Repo.insert_or_update()
  end

  def match_details(id) do
    Match
    |> Repo.get_by(id: id)
    |> Repo.preload([:match_events, :home_team, :away_team, :home_lineup, :away_lineup])
  end
end
