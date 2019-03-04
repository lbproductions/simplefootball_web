defmodule SimplefootballWebWeb.CompetitionControllerTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.{Repo, Competition, Season, Matchday}

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

    Repo.delete_all(Competition)
  end

  test "get an error because no current matchday is existing", %{conn: conn} do
    {:ok, bundesliga} =
      createCompetition(%Competition{
        name: "1. Bundesliga",
        competition_type: "bundesliga",
        icon_url:
          "https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Bundesliga_logo_%282017%29.svg/290px-Bundesliga_logo_%282017%29.svg.png"
      })

    {:ok, bundesliga2018} =
      Repo.insert(%Season{
        year: 2018,
        competition_id: bundesliga.id
      })

    {:ok, _} =
      Repo.insert(%Matchday{
        number: 24,
        description: "24. Spieltag",
        season_id: bundesliga2018.id,
        is_current_matchday: false
      })

    conn = get(conn, Routes.competition_path(conn, :current_matchday, bundesliga.id))

    assert response(conn, 422) == "No current matchday"

    Repo.delete_all(Matchday)
    Repo.delete_all(Season)
    Repo.delete_all(Competition)
  end

  def createCompetition(competition) do
    Repo.insert(competition)
  end
end
