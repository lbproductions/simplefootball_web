defmodule SimplefootballWeb.CompetitionRepo do
  import Ecto.{Query, Changeset}, warn: false

  alias SimplefootballWeb.{Repo, Competition}

  require Logger

  def competitions() do
    Competition
    |> Repo.all()
  end

  def competition_by_type(competition_type) do
    Competition
    |> Repo.get_by!(competition_type: competition_type)
    |> Repo.preload(seasons: [:matchdays])
  end

  def current_matchday(competition) do
    season = Enum.max_by(competition.seasons, fn season -> season.year end)

    Logger.debug(fn ->
      "season: #{inspect(season)}"
    end)

    current_matchday =
      List.first(Enum.filter(season.matchdays, fn matchday -> matchday.is_current_matchday end))

    if current_matchday == nil do
      nil
    else
      Repo.preload(current_matchday, matches: [:home_team, :away_team])
    end
  end

  def current_matchday_by_type(competition_type) do
    competition_by_type(competition_type)
    |> current_matchday()
  end
end
