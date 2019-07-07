defmodule SimplefootballWebWeb.CompetitionController do
  use SimplefootballWebWeb, :controller

  alias SimplefootballWeb.CompetitionRepo
  alias SimplefootballWebWeb.{CompetitionView, MatchdayView}

  require Logger

  def index(conn, _params) do
    json(conn, CompetitionView.render_list(CompetitionRepo.competitions()))
  end

  def current_matchday(conn, %{"competitionType" => competition_type}) do
    current_matchday = CompetitionRepo.current_matchday_by_type(competition_type)

    if current_matchday == nil do
      send_resp(conn, 404, "No current matchday")
    else
      Logger.debug(fn ->
        "current_matchday: #{inspect(current_matchday)}"
      end)

      json(conn, MatchdayView.render_matchday(current_matchday))
    end
  end

  def matchday(conn, %{
        "competitionType" => competition_type,
        "year" => year,
        "matchday_number" => matchday_number
      }) do
    {year, _} = Integer.parse(year)
    {matchday_number, _} = Integer.parse(matchday_number)
    matchday = CompetitionRepo.matchday_by_type(competition_type, year, matchday_number)

    if matchday == nil do
      send_resp(conn, 404, "No matchday found")
    else
      json(conn, MatchdayView.render_matchday(matchday))
    end
  end
end
