defmodule SimplefootballWeb.MatchdayRepo do
  import Ecto.{Query, Changeset}, warn: false

  alias SimplefootballWeb.{Repo, Matchday}

  require Logger

  def matchday_by(season_id: season_id, number: number) do
    Matchday
    |> Repo.get_by(season_id: season_id, number: number)
  end

  def update_or_create_matchday_by(season_id: season_id, number: number, changeset: changeset) do
    case matchday_by(season_id: season_id, number: number) do
      nil -> %Matchday{season_id: season_id, number: number}
      matchday -> matchday
    end
    |> Matchday.changeset(changeset)
    |> Repo.insert_or_update()
  end
end
