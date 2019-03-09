defmodule SimplefootballWebWeb.CompetitionControllerTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.{Repo, Competition}

  test "lists all competitions - no competitions", %{conn: conn} do
    conn = get(conn, Routes.competition_path(conn, :index))

    assert json_response(conn, 200) == []
  end

  test "lists all competitions - existing competitions", %{conn: conn} do
    createCompetition(%Competition{
      name: "1. Bundesliga",
      competition_type: "bundesliga",
      icon_url: "URL1"
    })

    createCompetition(%Competition{
      name: "2. Bundesliga",
      competition_type: "bundesliga2",
      icon_url: "URL2"
    })

    conn = get(conn, Routes.competition_path(conn, :index))

    assert json_response(conn, 200) == [
             %{
               "name" => "1. Bundesliga",
               "iconUrl" => "URL1",
               "competitionType" => "bundesliga"
             },
             %{
               "name" => "2. Bundesliga",
               "iconUrl" => "URL2",
               "competitionType" => "bundesliga2"
             }
           ]
  end

  def createCompetition(competition) do
    Repo.insert(competition)
  end
end
