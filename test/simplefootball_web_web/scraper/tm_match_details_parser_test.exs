defmodule SimplefootballWebWeb.TMMatchDetailsParserTest do
  use SimplefootballWebWeb.ConnCase, async: true

  require Logger

  alias SimplefootballWeb.TMMatchDetailsParser

  @tag :wip
  test "scraping match details from a live game" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/bundesliga_17_bvbbmg_liveDetails.html"
      )

    %{
      result: result
    } = TMMatchDetailsParser.scrape_live_match_details(result)

    assert result == "2:1"
  end

  @tag :wip
  test "scraping match details from a game report" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/bundesliga_2019_matchday_1_matchdetails_report_bvbfca.html"
      )

    %{
      result: result
    } = TMMatchDetailsParser.scrape_report_match_details(result)

    assert result == "5:1"
  end
end
