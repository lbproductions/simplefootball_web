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
      result: result,
      is_extra_time: is_extra_time
    } = TMMatchDetailsParser.scrape_live_match_details(result, '')

    assert result == "2:1"
    assert is_extra_time == false
  end

  @tag :wip
  test "scraping match details from a game report" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/bundesliga_2019_matchday_1_matchdetails_report_bvbfca.html"
      )

    %{
      result: result,
      is_extra_time: is_extra_time
    } = TMMatchDetailsParser.scrape_report_match_details(result, '')

    assert result == "5:1"
    assert is_extra_time == false
  end

  @tag :wip
  test "scraping match details from a game report after extra time" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/europaleague_matchdetails_report_afterExtraTime.html"
      )

    %{
      result: result,
      is_extra_time: is_extra_time
    } = TMMatchDetailsParser.scrape_report_match_details(result, '')

    assert result == "4:1"
    assert is_extra_time == true
  end

  @tag :wip
  test "scraping match details from a live game in extra time" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/europaleague_matchdetails_live_inExtraTime.html"
      )

    %{
      result: result,
      is_extra_time: is_extra_time
    } = TMMatchDetailsParser.scrape_report_match_details(result, '3292014')

    assert result == "0:1"
    assert is_extra_time == nil
  end
end
