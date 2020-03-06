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
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team
    } = TMMatchDetailsParser.scrape_live_match_details(result, '')

    assert result == "2:1"
    assert is_extra_time == false
    assert is_penalties == false
    assert DateTime.to_string(date) == "2018-12-21 19:30:00Z"
    assert home_team.name == "Borussia Dortmund"
    assert home_team.tm_identifier == "16"
    assert away_team.name == "Borussia Mönchengladbach"
    assert away_team.tm_identifier == "18"
  end

  @tag :wip
  test "scraping match details from a game report" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/bundesliga_2019_matchday_1_matchdetails_report_bvbfca.html"
      )

    %{
      result: result,
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team
    } = TMMatchDetailsParser.scrape_report_match_details(result, '')

    assert result == "5:1"
    assert is_extra_time == false
    assert is_penalties == false
    assert DateTime.to_string(date) == "2019-08-17 13:30:00Z"
    assert home_team.name == "Borussia Dortmund"
    assert home_team.tm_identifier == "16"
    assert away_team.name == "Borussia Mönchengladbach"
    assert away_team.tm_identifier == "18"
  end

  @tag :wip
  test "scraping match details from a game report after extra time" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/europaleague_matchdetails_report_afterExtraTime.html"
      )

    %{
      result: result,
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team
    } = TMMatchDetailsParser.scrape_report_match_details(result, '')

    assert result == "4:1"
    assert is_extra_time == true
    assert is_penalties == false
    assert DateTime.to_string(date) == "2020-02-27 17:55:00Z"
    assert home_team.name == "Istanbul Basaksehir FK"
    assert home_team.tm_identifier == "6890"
    assert away_team.name == "Sporting Lissabon"
    assert away_team.tm_identifier == "336"
  end

  @tag :wip
  test "scraping match details from a live game in extra time" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/europaleague_matchdetails_live_inExtraTime.html"
      )

    %{
      result: result,
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team
    } = TMMatchDetailsParser.scrape_live_match_details(result, '3292014')

    assert result == "0:1"
    assert is_extra_time == nil
    assert is_penalties == nil
    assert DateTime.to_string(date) == "2020-02-27 20:00:00Z"
    assert home_team.name == "FC Arsenal"
    assert home_team.tm_identifier == "11"
    assert away_team.name == "Olympiakos Piräus"
    assert away_team.tm_identifier == "683"
  end
end
