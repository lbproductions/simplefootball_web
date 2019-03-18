defmodule SimplefootballWeb.MatchdayScraper do
  alias SimplefootballWeb.{Competition, Season}
  @callback matchday(%Competition{}, %Season{}, :integer) :: map
end

defmodule SimplefootballWeb.Scraper do
  alias SimplefootballWeb.{MatchdayRepo, TeamRepo, MatchRepo}

  def matchday(scraper, competition, season, number) do
    result = scraper.matchday(competition, season, number)

    {:ok, matchday} = update_matchday(result.matchday, season.id, number)
    matches = update_matches(result.matches)

    %{
      matchday: matchday,
      matches: matches
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

  def update_matches(matches) do
    Enum.map(matches, fn match -> update_match(match) end)
  end

  def update_match(match) do
    {:ok, home_team} = update_team(match.home_team)
    {:ok, away_team} = update_team(match.away_team)
    {:ok, match} = MatchRepo.update_or_create_match_by_tm_identifier(match.tm_identifier, match)

    %{
      home_team: home_team,
      away_team: away_team,
      match: match
    }
  end
end
