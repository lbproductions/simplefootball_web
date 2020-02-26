defmodule SimplefootballWeb.TMMatchDetailsScraper do
  use Timex

  alias SimplefootballWeb.{TMHttpService, TMMatchDetailsParser, MatchDetailsScraper, Match}
  @behaviour MatchdayScraper

  @impl MatchDetailsScraper
  def match_details(match) do

    report_start_date = Timex.shift(match.date, hours: 36)
    match_is_enough_in_the_past_for_a_report = Timex.before?(Timex.today, report_start_date)
    is_before_match = Timex.before(match.date, Timex.today)
    is_live = match.isRunning || match_is_enough_in_the_past_for_a_report || is_before_match

    if is_live do
      data = TMHttpService.tm_live_match_details(match.tm_identifier)
      TMMatchDetailsParser.scrape_live_match_details(data)
    else
      data = TMHttpService.tm_report_match_details(match.tm_identifier)
      TMMatchDetailsParser.scrape_report_match_details(data)
    end
  end
end
