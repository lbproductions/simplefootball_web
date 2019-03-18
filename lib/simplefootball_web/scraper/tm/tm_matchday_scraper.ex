defmodule SimplefootballWeb.TMMatchdayScraper do
  alias SimplefootballWeb.{TMHttpService, TMParser, MatchdayScraper}
  @behaviour MatchdayScraper

  @impl MatchdayScraper
  def matchday(competition, season, number) do
    competition_identifier = TMHttpService.tm_competition_identifier(competition)
    data = TMHttpService.matchday(competition_identifier, season.year, number)
    TMParser.scrape_matchday(data)
  end
end
