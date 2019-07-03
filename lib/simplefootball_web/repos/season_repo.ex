defmodule SimplefootballWeb.SeasonRepo do
  import Ecto.{Query, Changeset}, warn: false

  alias SimplefootballWeb.{Repo, Season}

  def season_by_year(year: year, competition: competition) do
    Season
    |> Repo.get_by(year: year, competition_id: competition.id)
  end

  def find_or_create_season_by(year: year, competition: competition) do
    case season_by_year(year: year, competition: competition) do
      nil -> %Season{year: year, competition_id: competition.id}
      season -> season
    end
    |> Season.changeset(%{year: year, competition_id: competition.id})
    |> Repo.insert_or_update()
  end
end
