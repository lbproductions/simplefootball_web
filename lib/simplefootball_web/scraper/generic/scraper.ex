defmodule SimplefootballWeb.MatchdayScraper do
  alias SimplefootballWeb.{Competition, Season}
  @callback matchday(%Competition{}, %Season{}, :integer) :: map
  @callback current_matchday(%Competition{}) :: map
end

require Logger

defmodule SimplefootballWeb.Scraper do
  alias SimplefootballWeb.{MatchdayRepo, TeamRepo, MatchRepo, SeasonRepo, Competition}

  def matchday(scraper, competition, season, number) do
    result = scraper.matchday(competition, season, number)

    {:ok, matchday} = update_matchday(result.matchday, season.id, number)
    matches = update_matches(result.matches, matchday)

    %{
      matchday: matchday,
      matches: matches
    }
  end

  def current_matchday(scraper, competition) do
    result = scraper.current_matchday(competition)

    season = update_season(result.season, competition)

    update_result =
      case competition.competition_type do
        :dfbPokal -> update_dfbpokal_matchdays_and_matches(result, season)
        true -> update_matchday_and_matches(result, season)
      end

    Map.merge(update_result, %{season: season})
  end

  def update_season(year, competition) do
    {:ok, season} = SeasonRepo.find_or_create_season_by(year: year, competition: competition)
    season
  end

  def update_matchday_and_matches(scrape_result, season) do
    {:ok, matchday} = update_matchday(scrape_result, season.id, scrape_result.number)
    matches = update_matches(scrape_result.matches, matchday)
    current_matchday_update = MatchdayRepo.update_current_matchday(matchday, season)

    %{
      matchday: matchday,
      matches: matches,
      current_matchday_update: current_matchday_update
    }
  end

  def update_dfbpokal_matchdays_and_matches(scrape_result, season) do
    rounds = Competition.competition_rounds(:dfbPokal)
    matches_by_group = Enum.group_by(scrape_result.matches, fn match -> match.group end)

    matchdays =
      Enum.map(matches_by_group, fn {group, matches} ->
        number = Enum.find_index(rounds, fn e -> e end) + 1
        matchday_data = scrape_result
        matchday_data.description = group
        matchday_data.number = number
        {:ok, matchday} = update_matchday(matchday_data, season.id, number)
        matchday
      end)
      |> Enum.flat_map(fn x -> x end)
  end

  def update_matchday(matchday, season_id, number) do
    MatchdayRepo.update_or_create_matchday_by(
      season_id: season_id,
      number: number,
      changeset: matchday
    )
  end

  def update_team(team) do
    TeamRepo.update_or_create_team_by_tm_identifier(team.tm_identifier, team)
  end

  def update_matches(matches, matchday) do
    Enum.map(matches, fn match -> update_match(match, matchday) end)
  end

  def update_match(match, matchday) do
    {:ok, home_team} = update_team(match.home_team)
    {:ok, away_team} = update_team(match.away_team)

    {:ok, match} =
      MatchRepo.update_or_create_match_by_tm_identifier(
        match.tm_identifier,
        Map.merge(match, %{
          home_team_id: home_team.id,
          away_team_id: away_team.id,
          matchday_id: matchday.id
        })
      )

    %{
      home_team: home_team,
      away_team: away_team,
      match: match
    }
  end
end
