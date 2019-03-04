defmodule SimplefootballWebWeb.CompetitionController do
  use SimplefootballWebWeb, :controller

  alias SimplefootballWeb.{Repo, Competition}
  alias SimplefootballWebWeb.CompetitionView

  def index(conn, _params) do
    data = competitions()
    json(conn, CompetitionView.renderList(data))
  end

  def competitions() do
    Competition
    |> Repo.all()
  end
end
