defmodule SimplefootballWebWeb.CompetitionController do
  use SimplefootballWebWeb, :controller

  alias SimplefootballWeb.{Repo, Competition}
  alias SimplefootballWebWeb.{CompetitionView, MatchdayView}

  require Logger

  def index(conn, _params) do
    data = competitions()
    json(conn, CompetitionView.renderList(data))
  end

  def current_matchday(conn, assigns) do
    competition = competitionByType(assigns["competitionType"])
    season = Enum.max_by(competition.seasons, fn season -> season.year end)

    Logger.debug(fn ->
      "season: #{inspect(season)}"
    end)

    current_matchday =
      List.first(Enum.filter(season.matchdays, fn matchday -> matchday.is_current_matchday end))

    if current_matchday == nil do
      send_resp(conn, 422, "No current matchday")
    else
      loadedMatchday = Repo.preload(current_matchday, matches: [:home_team, :away_team])

      Logger.debug(fn ->
        "loadedMatchday: #{inspect(loadedMatchday)}"
      end)

      json(conn, MatchdayView.renderMatchday(loadedMatchday))
    end
  end

  def competitions() do
    Competition
    |> Repo.all()
  end

  def competitionByType(competition_type) do
    Competition
    |> Repo.get_by!(competition_type: competition_type)
    |> Repo.preload(seasons: [:matchdays])
  end
end
