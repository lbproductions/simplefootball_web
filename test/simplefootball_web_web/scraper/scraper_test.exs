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

  @current_matchday_dfbpokal_result_matches [
    %{
      is_started: true,
      is_running: false,
      result: "0:2",
      is_penalty: false,
      is_extra_time: false,
      group: "Finale",
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
    },
    %{
      is_started: true,
      is_running: false,
      result: "1:3",
      is_penalty: false,
      is_extra_time: false,
      group: "1.Runde",
      home_team: %{
        name: "Union Berlin",
        tm_identifier: "89"
      },
      away_team: %{
        name: "Bor. Dortmund",
        tm_identifier: "16"
      },
      tm_identifier: "3058723",
      date: DateTime.from_iso8601("2019-05-17 22:00:00Z") |> elem(1)
    }
  ]

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

  @current_matchday_dfbpokal_result %{
    season: 2019,
    description: "19/20",
    matches: @current_matchday_dfbpokal_result_matches,
    is_current_matchday: true
  }

  @impl MatchdayScraper
  def matchday(_competition, _season, _number) do
  end

  @impl MatchdayScraper
  def current_matchday(competition) do
    case competition.competition_type do
      :dfbPokal -> @current_matchday_dfbpokal_result
      :bundesliga -> @current_matchday_result
    end
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
        competition_type: :bundesliga,
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
        competition_type: :bundesliga,
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

    assert updated_current_matchday.is_current_matchday == true
  end

  test "get current DFB Pokal matchday" do
    Repo.delete_all(Match)
    Repo.delete_all(Team)
    Repo.delete_all(Matchday)
    Repo.delete_all(Season)
    Repo.delete_all(Competition)

    {:ok, competition} =
      Repo.insert(%Competition{
        name: "DFB-Pokal",
        competition_type: :dfbPokal,
        icon_url: ""
      })

    %{
      matchday_results: matchday_results,
      current_matchday_update: current_matchday_update
    } = Scraper.current_matchday(SimplefootballWebWeb.MatchdayScraperMock, competition)

    assert length(matchday_results) == 2

    current_matchday =
      Enum.max_by(matchday_results, fn result -> result.matchday.number end).matchday

    first_matchday =
      Enum.min_by(matchday_results, fn result -> result.matchday.number end).matchday

    current_matchday_match =
      Enum.max_by(matchday_results, fn result -> result.matchday.number end).matches
      |> Enum.map(fn obj -> obj.match end)
      |> List.first()

    first_matchday_match =
      Enum.min_by(matchday_results, fn result -> result.matchday.number end).matches
      |> Enum.map(fn obj -> obj.match end)
      |> List.first()

    expected_current_matchday_match =
      SimplefootballWebWeb.MatchdayScraperMock.current_matchday(competition).matches
      |> List.first()

    expected_first_matchday_match =
      SimplefootballWebWeb.MatchdayScraperMock.current_matchday(competition).matches
      |> List.last()

    assert current_matchday.is_current_matchday == true
    assert first_matchday.is_current_matchday == false

    assert current_matchday.number == 6
    assert first_matchday.number == 1

    assert current_matchday.description == expected_current_matchday_match.group
    assert first_matchday.description == expected_first_matchday_match.group

    assert current_matchday_match.matchday_id == current_matchday.id
    assert first_matchday_match.matchday_id == first_matchday.id

    assert current_matchday_match.result == expected_current_matchday_match.result
    assert first_matchday_match.result == expected_first_matchday_match.result

    assert current_matchday_update.changed_number_of_matchdays == 1
  end
end
