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
end
