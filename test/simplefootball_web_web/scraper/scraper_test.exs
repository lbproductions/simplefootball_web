defmodule SimplefootballWebWeb.MatchdayScraperMock do
  @behaviour MatchdayScraper

  @current_matchday_result_matches [
    %{
      is_started: true,
      is_running: true,
      result: "0:2",
      is_penalty: false,
      is_extra_time: false,
      home_team: %{
        name: "Bor. M'gladbach",
        tm_identifier: "18"
      },
      away_team: %{
        name: "Bor. Dortmund",
        tm_identifier: "16"
      },
      tm_identifier: "3058722",
      date: DateTime.from_iso8601("2019-05-17 22:00:00Z") |> elem(1)
    }
  ]

  def current_matchday_result_matches() do
    @current_matchday_result_matches
  end

  @current_matchday_result %{
    season: 2018,
    number: 34,
    description: "34. Spieltag",
    matches: @current_matchday_result_matches,
    is_current_matchday: true
  }

  def current_matchday_result() do
    @current_matchday_result
  end

  @impl MatchdayScraper
  def matchday(_competition, _season, _number) do
  end

  @impl MatchdayScraper
  def current_matchday(_competition) do
    @current_matchday_result
  end
end

defmodule SimplefootballWebWeb.ScraperTest do
  use SimplefootballWebWeb.ConnCase, async: false

  require Logger
  alias SimplefootballWeb.{Scraper, Repo, Match, Team, Matchday, Season, Competition}

  test "get current matchday with no previous existing data" do
    Repo.delete_all(Match)
    Repo.delete_all(Team)
    Repo.delete_all(Matchday)
    Repo.delete_all(Season)

    {:ok, competition} =
      Repo.insert(%Competition{
        name: "1. Bundesliga",
        competition_type: "bundesliga",
        icon_url:
          "https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Bundesliga_logo_%282017%29.svg/290px-Bundesliga_logo_%282017%29.svg.png"
      })

    %{
      matchday: matchday,
      matches: matches,
      season: season,
      current_matchday_update: current_matchday_update
    } = Scraper.current_matchday(SimplefootballWebWeb.MatchdayScraperMock, competition)

    assert season.year ==
             SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result().season

    assert matchday.season_id != nil
    assert matchday.season_id == season.id

    assert matchday.description ==
             SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result().description

    assert matchday.number ==
             SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result().number

    assert length(matches) == 1
    %{match: match, home_team: home_team, away_team: away_team} = Enum.at(matches, 0)
    assert match.matchday_id == matchday.id
    assert match.home_team_id == home_team.id
    assert match.away_team_id == away_team.id

    assert current_matchday_update.changed_number_of_matchdays == 0
  end

  test "get current matchday with previous existing data" do
    Repo.delete_all(Match)
    Repo.delete_all(Team)
    Repo.delete_all(Matchday)
    Repo.delete_all(Season)
    Repo.delete_all(Competition)

    {:ok, competition} =
      Repo.insert(%Competition{
        name: "1. Bundesliga",
        competition_type: "bundesliga",
        icon_url:
          "https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Bundesliga_logo_%282017%29.svg/290px-Bundesliga_logo_%282017%29.svg.png"
      })

    {:ok, bundesliga2018} =
      Repo.insert(%Season{
        year: 2018,
        competition_id: competition.id
      })

    {:ok, inserted_matchday} =
      Repo.insert(%Matchday{
        number: 34,
        season_id: bundesliga2018.id
      })

    {:ok, old_current_matchday} =
      Repo.insert(%Matchday{
        number: 33,
        season_id: bundesliga2018.id,
        is_current_matchday: true
      })

    {:ok, inserted_match} =
      Repo.insert(%Match{
        tm_identifier: "3058722"
      })

    {:ok, inserted_home_team} =
      Repo.insert(%Team{
        tm_identifier: "18"
      })

    {:ok, inserted_away_team} =
      Repo.insert(%Team{
        tm_identifier: "16"
      })

    %{
      matchday: matchday,
      matches: matches,
      season: season,
      current_matchday_update: current_matchday_update
    } = Scraper.current_matchday(SimplefootballWebWeb.MatchdayScraperMock, competition)

    assert season.competition_id == competition.id

    assert season.year ==
             SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result().season

    assert matchday.season_id == bundesliga2018.id

    assert matchday.id == inserted_matchday.id

    matchday.description ==
      SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result().description

    assert matchday.number ==
             SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result().number

    assert length(matches) == 1
    %{match: match, home_team: home_team, away_team: away_team} = Enum.at(matches, 0)
    assert match.id == inserted_match.id
    assert match.matchday_id == matchday.id
    assert match.home_team_id == home_team.id
    assert match.away_team_id == away_team.id
    assert home_team.id == inserted_home_team.id

    assert home_team.name ==
             Enum.at(
               SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result_matches(),
               0
             ).home_team.name

    assert away_team.id == inserted_away_team.id

    assert away_team.name ==
             Enum.at(
               SimplefootballWebWeb.MatchdayScraperMock.current_matchday_result_matches(),
               0
             ).away_team.name

    assert current_matchday_update.changed_number_of_matchdays == 1

    updated_old_matchday = Repo.get!(Matchday, old_current_matchday.id)
    assert updated_old_matchday.is_current_matchday == false

    updated_current_matchday = Repo.get!(Matchday, matchday.id)

    Logger.debug(fn ->
      "updated_current_matchday: #{inspect(updated_current_matchday)}"
    end)

    assert updated_current_matchday.is_current_matchday == true
  end

  @tag :wip
  test "get current DFB Pokal matchday" do
    Repo.delete_all(Match)
    Repo.delete_all(Team)
    Repo.delete_all(Matchday)
    Repo.delete_all(Season)
    Repo.delete_all(Competition)

    {:ok, competition} =
      Repo.insert(%Competition{
        name: "DFB-Pokal",
        competition_type: "dfbPokal",
        icon_url: ""
      })

    %{
      matchday: matchday,
      matches: matches,
      season: season,
      current_matchday_update: current_matchday_update
    } = Scraper.current_matchday(SimplefootballWebWeb.MatchdayScraperMock, competition)
  end
end
