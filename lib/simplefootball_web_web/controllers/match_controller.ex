defmodule SimplefootballWebWeb.MatchController do
  use SimplefootballWebWeb, :controller

  alias SimplefootballWeb.MatchRepo
  alias SimplefootballWebWeb.{MatchView}

  require Logger

  def show(conn, %{"id" => id}) do
    match = MatchRepo.match_details(id)
    json(conn, MatchView.render_match(match))
  end
end
