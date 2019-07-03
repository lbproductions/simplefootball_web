defmodule SimplefootballWeb.MatchdayScraper do
  alias SimplefootballWeb.{Competition, Season}
  @callback matchday(%Competition{}, %Season{}, :integer) :: map
  @callback current_matchday(%Competition{}) :: map
end

require Logger

defmodule SimplefootballWeb.Scraper do
  alias SimplefootballWeb.{MatchdayRepo, TeamRepo, MatchRepo, SeasonRepo}

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

    {:ok, season} =
      SeasonRepo.find_or_create_season_by(year: result.season, competition: competition)

    {:ok, matchday} = update_matchday(result, season.id, result.number)
    matches = update_matches(result.matches, matchday)
    current_matchday_update = MatchdayRepo.update_current_matchday(matchday, season)

    %{
      matchday: matchday,
      matches: matches,
      season: season,
      current_matchday_update: current_matchday_update
    }
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
