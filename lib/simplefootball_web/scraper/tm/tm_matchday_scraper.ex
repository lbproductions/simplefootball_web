defmodule SimplefootballWeb.TMMatchdayScraper do
  alias SimplefootballWeb.{TMHttpService, TMParser, MatchdayScraper, Competition}
  @behaviour MatchdayScraper

  @impl MatchdayScraper
  def matchday(competition, season, number) do
    competition_identifier = TMHttpService.tm_competition_identifier(competition)
    data = TMHttpService.matchday(competition_identifier, season.year, number)
    result = TMParser.scrape_matchday(data)

    description =
      case competition.competition_type do
        :dfbPokal -> Competition.competition_rounds(competition) |> Enum.at(number - 1)
        _ -> "#{number}. Spieltag"
      end

    Map.merge(result, %{
      description: description,
      number: number,
      season: season
    })
  end

  @impl MatchdayScraper
  def current_matchday(competition) do
    data = TMHttpService.tm_current_matchday(competition)
    TMParser.scrape_current_matchday(data, competition)
  end
end
