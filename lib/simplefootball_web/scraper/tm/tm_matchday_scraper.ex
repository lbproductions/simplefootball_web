defmodule SimplefootballWeb.TMMatchdayScraper do
  alias SimplefootballWeb.{TMHttpService, TMParser, MatchdayScraper}
  @behaviour MatchdayScraper

  @impl MatchdayScraper
  def matchday(competition, season, number) do
    competition_identifier = TMHttpService.tm_competition_identifier(competition)
    data = TMHttpService.matchday(competition_identifier, season.year, number)
    %{home_team: home_team,
    away_team: away_team,
    match: match} = TMParser.scrape_matchday(data)

    match
  end
end
