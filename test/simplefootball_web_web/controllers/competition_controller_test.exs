defmodule SimplefootballWebWeb.CompetitionControllerTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.{Repo, Competition, Season, Matchday, Match, Team}

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

    conn =
      get(conn, Routes.competition_path(conn, :current_matchday, bundesliga.competition_type))

    assert response(conn, 404) == "No current matchday"

    Repo.delete_all(Matchday)
    Repo.delete_all(Season)
    Repo.delete_all(Competition)
  end

  test "get current matchday with existing one", %{conn: conn} do
    date = DateTime.truncate(DateTime.utc_now(), :second)

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

    {:ok, bundesliga2018matchday24} =
      Repo.insert(%Matchday{
        number: 24,
        description: "24. Spieltag",
        season_id: bundesliga2018.id,
        is_current_matchday: true
      })

    {:ok, bundesliga2018matchday24match1homeTeam} =
      Repo.insert(%Team{
        name: "Borussia Dortmund",
        abbreviation: "BVB"
      })

    {:ok, bundesliga2018matchday24match1awayTeam} =
      Repo.insert(%Team{
        name: "Bayer Leverkusen",
        abbreviation: "B04"
      })

    {:ok, _} =
      Repo.insert(%Match{
        date: date,
        result: "2:1",
        matchday_id: bundesliga2018matchday24.id,
        after_penalties: false,
        extra_time: false,
        home_team_id: bundesliga2018matchday24match1homeTeam.id,
        away_team_id: bundesliga2018matchday24match1awayTeam.id
      })

    conn =
      get(conn, Routes.competition_path(conn, :current_matchday, bundesliga.competition_type))

    assert json_response(conn, 200) == %{
             "number" => 24,
             "description" => "24. Spieltag",
             "isCurrentMatchday" => true,
             "matches" => [
               %{
                 "afterPenalties" => false,
                 "extraTime" => false,
                 "result" => "2:1",
                 "date" => DateTime.to_string(date),
                 "homeTeam" => %{
                   "name" => "Borussia Dortmund",
                   "abbreviation" => "BVB"
                 },
                 "awayTeam" => %{
                   "name" => "Bayer Leverkusen",
                   "abbreviation" => "B04"
                 }
               }
             ]
           }

    Repo.delete_all(Match)
    Repo.delete_all(Team)
    Repo.delete_all(Matchday)
    Repo.delete_all(Season)
    Repo.delete_all(Competition)
  end

  def createCompetition(competition) do
    Repo.insert(competition)
  end
end
