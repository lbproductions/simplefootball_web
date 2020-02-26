defmodule SimplefootballWebWeb.TMParserTest do
  use SimplefootballWebWeb.ConnCase, async: true

  require Logger

  alias SimplefootballWeb.TMParser

  test "scraping a complete matchday" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/bundesliga_2018_18.html")

    %{matches: matches} = TMParser.scrape_matchday(result)

    assert length(matches) == 9

    match = Enum.at(matches, 0)
    assert match.home_team.name == "TSG Hoffenheim"
    assert match.home_team.abbreviation == "1899"
    assert match.home_team.tm_identifier == "533"
    assert match.away_team.name == "Bayern München"
    assert match.away_team.abbreviation == "FCB"
    assert match.away_team.tm_identifier == "27"
    assert match.result == "1:3"
    assert match.tm_identifier == "3058569"
    assert DateTime.to_string(match.date) == "2019-01-18 19:30:00Z"

    match = Enum.at(matches, 1)
    assert match.home_team.name == "FC Augsburg"
    assert match.home_team.abbreviation == "FCA"
    assert match.home_team.tm_identifier == "167"
    assert match.away_team.name == "F. Düsseldorf"
    assert match.away_team.abbreviation == "F95"
    assert match.away_team.tm_identifier == "38"
    assert match.result == "1:2"
    assert match.tm_identifier == "3058574"
    assert DateTime.to_string(match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 2)
    assert match.home_team.name == "E. Frankfurt"
    assert match.home_team.abbreviation == "SGE"
    assert match.home_team.tm_identifier == "24"
    assert match.away_team.name == "SC Freiburg"
    assert match.away_team.abbreviation == "SC"
    assert match.away_team.tm_identifier == "60"
    assert match.result == "3:1"
    assert match.tm_identifier == "3058573"
    assert DateTime.to_string(match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 3)
    assert match.home_team.name == "Bay. Leverkusen"
    assert match.home_team.abbreviation == "Bayer"
    assert match.home_team.tm_identifier == "15"
    assert match.away_team.name == "Bor. M'gladbach"
    assert match.away_team.abbreviation == "BMG"
    assert match.away_team.tm_identifier == "18"
    assert match.result == "0:1"
    assert match.tm_identifier == "3058570"
    assert DateTime.to_string(match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 4)
    assert match.home_team.name == "Hannover 96"
    assert match.home_team.abbreviation == "H96"
    assert match.home_team.tm_identifier == "42"
    assert match.away_team.name == "Werder Bremen"
    assert match.away_team.abbreviation == "Werder"
    assert match.away_team.tm_identifier == "86"
    assert match.result == "0:1"
    assert match.tm_identifier == "3058575"
    assert DateTime.to_string(match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 5)
    assert match.home_team.name == "VfB Stuttgart"
    assert match.home_team.abbreviation == "VfB"
    assert match.home_team.tm_identifier == "79"
    assert match.away_team.name == "1.FSV Mainz 05"
    assert match.away_team.abbreviation == "Mainz"
    assert match.away_team.tm_identifier == "39"
    assert match.result == "2:3"
    assert match.tm_identifier == "3058572"
    assert DateTime.to_string(match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 6)
    assert match.home_team.name == "RB Leipzig"
    assert match.home_team.abbreviation == "RBL"
    assert match.home_team.tm_identifier == "23826"
    assert match.away_team.name == "Bor. Dortmund"
    assert match.away_team.abbreviation == "BVB"
    assert match.away_team.tm_identifier == "16"
    assert match.result == "0:1"
    assert match.tm_identifier == "3058571"
    assert DateTime.to_string(match.date) == "2019-01-19 17:30:00Z"

    match = Enum.at(matches, 7)
    assert match.home_team.name == "1.FC Nürnberg"
    assert match.home_team.abbreviation == "1.FCN"
    assert match.home_team.tm_identifier == "4"
    assert match.away_team.name == "Hertha BSC"
    assert match.away_team.abbreviation == "Hertha"
    assert match.away_team.tm_identifier == "44"
    assert match.result == "1:3"
    assert match.tm_identifier == "3058576"
    assert DateTime.to_string(match.date) == "2019-01-20 14:30:00Z"

    match = Enum.at(matches, 8)
    assert match.home_team.name == "FC Schalke 04"
    assert match.home_team.abbreviation == "S04"
    assert match.home_team.tm_identifier == "33"
    assert match.away_team.name == "VfL Wolfsburg"
    assert match.away_team.abbreviation == "VfL"
    assert match.away_team.tm_identifier == "82"
    assert match.result == "2:1"
    assert match.tm_identifier == "3058568"
    assert DateTime.to_string(match.date) == "2019-01-20 17:00:00Z"
  end

  test "scraping an incomplete matchday" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/bundesliga_2018_25_incomplete.html")

    %{matches: matches} = TMParser.scrape_matchday(result)

    assert length(matches) == 9

    match = Enum.at(matches, 0)
    assert match.home_team.name == "Werder Bremen"
    assert match.home_team.abbreviation == "Werder"
    assert match.home_team.tm_identifier == "86"
    assert match.away_team.name == "FC Schalke 04"
    assert match.away_team.abbreviation == "S04"
    assert match.away_team.tm_identifier == "33"
    assert match.result == "4:2"
    assert match.tm_identifier == "3058643"
    assert DateTime.to_string(match.date) == "2019-03-08 19:30:00Z"

    match = Enum.at(matches, 1)
    assert match.home_team.name == "SC Freiburg"
    assert match.home_team.abbreviation == "SC"
    assert match.home_team.tm_identifier == "60"
    assert match.away_team.name == "Hertha BSC"
    assert match.away_team.abbreviation == "Hertha"
    assert match.away_team.tm_identifier == "44"
    assert match.result == "2:1"
    assert match.tm_identifier == "3058645"
    assert DateTime.to_string(match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 2)
    assert match.home_team.name == "RB Leipzig"
    assert match.home_team.abbreviation == "RBL"
    assert match.home_team.tm_identifier == "23826"
    assert match.away_team.name == "FC Augsburg"
    assert match.away_team.abbreviation == "FCA"
    assert match.away_team.tm_identifier == "167"
    assert match.result == "0:0"
    assert match.tm_identifier == "3058642"
    assert DateTime.to_string(match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 3)
    assert match.home_team.name == "Bayern München"
    assert match.home_team.abbreviation == "FCB"
    assert match.home_team.tm_identifier == "27"
    assert match.away_team.name == "VfL Wolfsburg"
    assert match.away_team.abbreviation == "VfL"
    assert match.away_team.tm_identifier == "82"
    assert match.result == "6:0"
    assert match.tm_identifier == "3058639"
    assert DateTime.to_string(match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 4)
    assert match.home_team.name == "Bor. Dortmund"
    assert match.home_team.abbreviation == "BVB"
    assert match.home_team.tm_identifier == "16"
    assert match.away_team.name == "VfB Stuttgart"
    assert match.away_team.abbreviation == "VfB"
    assert match.away_team.tm_identifier == "79"
    assert match.result == "3:1"
    assert match.tm_identifier == "3058641"
    assert DateTime.to_string(match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 5)
    assert match.home_team.name == "1.FSV Mainz 05"
    assert match.home_team.abbreviation == "Mainz"
    assert match.home_team.tm_identifier == "39"
    assert match.away_team.name == "Bor. M'gladbach"
    assert match.away_team.abbreviation == "BMG"
    assert match.away_team.tm_identifier == "18"
    assert match.result == "0:1"
    assert match.tm_identifier == "3058646"
    assert DateTime.to_string(match.date) == "2019-03-09 17:30:00Z"

    match = Enum.at(matches, 6)
    assert match.home_team.name == "TSG Hoffenheim"
    assert match.home_team.abbreviation == "1899"
    assert match.home_team.tm_identifier == "533"
    assert match.away_team.name == "1.FC Nürnberg"
    assert match.away_team.abbreviation == "1.FCN"
    assert match.away_team.tm_identifier == "4"
    assert match.result == "2:1"
    assert match.tm_identifier == "3058640"
    assert DateTime.to_string(match.date) == "2019-03-10 14:30:00Z"

    match = Enum.at(matches, 7)
    assert match.home_team.name == "Hannover 96"
    assert match.home_team.abbreviation == "H96"
    assert match.home_team.tm_identifier == "42"
    assert match.away_team.name == "Bay. Leverkusen"
    assert match.away_team.abbreviation == "Bayer"
    assert match.away_team.tm_identifier == "15"
    assert match.result == "-:-"
    assert match.tm_identifier == "3058644"
    assert DateTime.to_string(match.date) == "2019-03-10 17:00:00Z"

    match = Enum.at(matches, 8)
    assert match.home_team.name == "F. Düsseldorf"
    assert match.home_team.abbreviation == "F95"
    assert match.home_team.tm_identifier == "38"
    assert match.away_team.name == "E. Frankfurt"
    assert match.away_team.abbreviation == "SGE"
    assert match.away_team.tm_identifier == "24"
    assert match.result == "-:-"
    assert match.tm_identifier == "3058647"
    assert DateTime.to_string(match.date) == "2019-03-11 19:30:00Z"
  end

  test "scraping current complete finished matchday of Bundesliga" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/bundesliga_current_2018_34_finished.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :bundesliga
      })

    assert description == "34. Spieltag"
    assert length(matches) == 9
    assert number == 34
    assert season == 2018

    match = Enum.at(matches, 0)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "5:1"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "Bayern München"
    assert match.home_team.tm_identifier == "27"
    assert match.away_team.name == "E. Frankfurt"
    assert match.away_team.tm_identifier == "24"
    assert match.tm_identifier == "3058720"

    match = Enum.at(matches, 1)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "0:0"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "FC Schalke 04"
    assert match.home_team.tm_identifier == "33"
    assert match.away_team.name == "VfB Stuttgart"
    assert match.away_team.tm_identifier == "79"
    assert match.tm_identifier == "3058721"

    match = Enum.at(matches, 2)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "0:2"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "Bor. M'gladbach"
    assert match.home_team.tm_identifier == "18"
    assert match.away_team.name == "Bor. Dortmund"
    assert match.away_team.tm_identifier == "16"
    assert match.tm_identifier == "3058722"

    match = Enum.at(matches, 3)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "1:5"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "Hertha BSC"
    assert match.home_team.tm_identifier == "44"
    assert match.away_team.name == "Bay. Leverkusen"
    assert match.away_team.tm_identifier == "15"
    assert match.tm_identifier == "3058723"

    match = Enum.at(matches, 4)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "2:1"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "Werder Bremen"
    assert match.home_team.tm_identifier == "86"
    assert match.away_team.name == "RB Leipzig"
    assert match.away_team.tm_identifier == "23826"
    assert match.tm_identifier == "3058724"

    match = Enum.at(matches, 5)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "5:1"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "SC Freiburg"
    assert match.home_team.tm_identifier == "60"
    assert match.away_team.name == "1.FC Nürnberg"
    assert match.away_team.tm_identifier == "4"
    assert match.tm_identifier == "3058725"

    match = Enum.at(matches, 6)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "4:2"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "1.FSV Mainz 05"
    assert match.home_team.tm_identifier == "39"
    assert match.away_team.name == "TSG Hoffenheim"
    assert match.away_team.tm_identifier == "533"
    assert match.tm_identifier == "3058726"

    match = Enum.at(matches, 7)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "8:1"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "VfL Wolfsburg"
    assert match.home_team.tm_identifier == "82"
    assert match.away_team.name == "FC Augsburg"
    assert match.away_team.tm_identifier == "167"
    assert match.tm_identifier == "3058727"

    match = Enum.at(matches, 8)
    assert DateTime.to_string(match.date) == "2019-05-17 22:00:00Z"
    assert match.is_started == true
    assert match.is_running == false
    assert match.result == "2:1"
    assert match.is_penalty == false
    assert match.is_extra_time == false
    assert match.home_team.name == "F. Düsseldorf"
    assert match.home_team.tm_identifier == "38"
    assert match.away_team.name == "Hannover 96"
    assert match.away_team.tm_identifier == "42"
    assert match.tm_identifier == "3058728"
  end

  test "scraping the upcoming first matchday of 1. Bundesliga 19/20" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/bundesliga_current_2019_1_upcoming.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :bundesliga
      })

    assert description == "1. Spieltag"
    assert length(matches) == 9
    assert number == 1
    assert season == 2019

    match = Enum.at(matches, 0)
    assert DateTime.to_string(match.date) == "2019-08-16 18:30:00Z"
    assert match.group == nil
    is_bauern(match.home_team)
    is_hertha(match.away_team)
    assert match.tm_identifier == "3203424"

    match = Enum.at(matches, 1)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_dortmund(match.home_team)
    is_augsburg(match.away_team)
    assert match.tm_identifier == "3203425"

    match = Enum.at(matches, 2)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_leverkusen(match.home_team)
    is_paderborn(match.away_team)
    assert match.tm_identifier == "3203426"

    match = Enum.at(matches, 3)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_gladbach(match.home_team)
    is_scheisse(match.away_team)
    assert match.tm_identifier == "3203427"

    match = Enum.at(matches, 4)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_wolfsburg(match.home_team)
    is_koeln(match.away_team)
    assert match.tm_identifier == "3203428"

    match = Enum.at(matches, 5)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_frankfurt(match.home_team)
    is_hoffenheim(match.away_team)
    assert match.tm_identifier == "3203429"

    match = Enum.at(matches, 6)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_bremen(match.home_team)
    is_duesseldorf(match.away_team)
    assert match.tm_identifier == "3203430"

    match = Enum.at(matches, 7)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_freiburg(match.home_team)
    is_mainz(match.away_team)
    assert match.tm_identifier == "3203431"

    match = Enum.at(matches, 8)
    assert DateTime.to_string(match.date) == "2019-08-16 22:00:00Z"
    assert match.group == nil
    is_union(match.home_team)
    is_leipzig(match.away_team)
    assert match.tm_identifier == "3203432"
  end

  test "scraping matchday 8 of 1. Bundesliga season 2019" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/bundesliga_2019_8_complete.html")

    %{matches: matches} = TMParser.scrape_matchday(result)

    assert length(matches) == 9

    match = Enum.at(matches, 0)
    assert DateTime.to_string(match.date) == "2019-10-18 18:30:00Z"
    is_frankfurt(match.home_team)
    is_leverkusen(match.away_team)
    assert match.tm_identifier == "3203498"

    match = Enum.at(matches, 1)
    assert DateTime.to_string(match.date) == "2019-10-19 13:30:00Z"
    is_leipzig(match.home_team)
    is_wolfsburg(match.away_team)
    assert match.tm_identifier == "3203497"

    match = Enum.at(matches, 2)
    assert DateTime.to_string(match.date) == "2019-10-19 13:30:00Z"
    is_bremen(match.home_team)
    is_hertha(match.away_team)
    assert match.tm_identifier == "3203499"

    match = Enum.at(matches, 3)
    assert DateTime.to_string(match.date) == "2019-10-19 13:30:00Z"
    is_duesseldorf(match.home_team)
    is_mainz(match.away_team)
    assert match.tm_identifier == "3203501"

    match = Enum.at(matches, 4)
    assert DateTime.to_string(match.date) == "2019-10-19 13:30:00Z"
    is_augsburg(match.home_team)
    is_bauern(match.away_team)
    assert match.tm_identifier == "3203502"

    match = Enum.at(matches, 5)
    assert DateTime.to_string(match.date) == "2019-10-19 13:30:00Z"
    is_union(match.home_team)
    is_freiburg(match.away_team)
    assert match.tm_identifier == "3203504"

    match = Enum.at(matches, 6)
    assert DateTime.to_string(match.date) == "2019-10-19 16:30:00Z"
    is_dortmund(match.home_team)
    is_gladbach(match.away_team)
    assert match.tm_identifier == "3203496"

    match = Enum.at(matches, 7)
    assert DateTime.to_string(match.date) == "2019-10-20 13:30:00Z"
    is_koeln(match.home_team)
    is_paderborn(match.away_team)
    assert match.tm_identifier == "3203503"

    match = Enum.at(matches, 8)
    assert DateTime.to_string(match.date) == "2019-10-20 16:00:00Z"
    is_hoffenheim(match.home_team)
    is_scheisse(match.away_team)
    assert match.tm_identifier == "3203500"
  end

  test "scraping current complete finished matchday of 2. Bundesliga" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/bundesliga2_current_2018_34_finished.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :bundesliga2
      })

    assert description == "34. Spieltag"
    assert length(matches) == 9
    assert number == 34
    assert season == 2018

    Logger.debug(fn ->
      "matches: #{inspect(matches)}"
    end)
  end

  test "scraping current complete finished matchday of Premier League" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/premierleague_current_2018_38_finished.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :premierLeague
      })

    assert description == "38. Spieltag"
    assert length(matches) == 10
    assert number == 38
    assert season == 2018

    Logger.debug(fn ->
      "matches: #{inspect(matches)}"
    end)
  end

  test "scraping current complete finished matchday of La Liga" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/laliga_current_2018_38_finished.html")

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :laLiga
      })

    assert description == "38. Spieltag"
    assert length(matches) == 10
    assert number == 38
    assert season == 2018

    Logger.debug(fn ->
      "matches: #{inspect(matches)}"
    end)
  end

  test "scraping current complete finished matchday of Serie A" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/serieA_current_2018_38_finished.html")

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :serieA
      })

    assert description == "38. Spieltag"
    assert length(matches) == 10
    assert number == 38
    assert season == 2018

    Logger.debug(fn ->
      "matches: #{inspect(matches)}"
    end)
  end

  test "scraping current complete finished matchday of Ligue 1" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/ligue1_current_2018_38_finished.html")

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :ligue1
      })

    assert description == "38. Spieltag"
    assert length(matches) == 10
    assert number == 38
    assert season == 2018

    Logger.debug(fn ->
      "matches: #{inspect(matches)}"
    end)
  end

  test "scraping current complete finished matchday of Regionalliga West" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/regionalligaWest_current_2018_34_finished.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :regionalligaWest
      })

    assert description == "34. Spieltag"
    assert length(matches) == 9
    assert number == 34
    assert season == 2018

    Logger.debug(fn ->
      "matches: #{inspect(matches)}"
    end)
  end

  test "scraping current upcoming matchday of Regionalliga West with no scheduled matches" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/regionalligaWest_current_2019_1_noMatches.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :regionalligaWest
      })

    assert description == "1. Spieltag"
    assert length(matches) == 0
    assert number == 1
    assert season == 2019
  end

  test "scraping current complete competition of DFB Pokal" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/dfbpokal_current_2018_finished.html")

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :dfbPokal
      })

    Logger.debug(fn ->
      "pokal matches: #{inspect(matches)}"
    end)

    assert description == "KO-Runde 18/19"
    assert length(matches) == 63
    assert season == 2018

    finale = Enum.filter(matches, fn match -> match.group == "Finale" end)
    assert length(finale) == 1

    half_finale = Enum.filter(matches, fn match -> match.group == "Halbfinale" end)
    assert length(half_finale) == 2

    quarter_finale = Enum.filter(matches, fn match -> match.group == "Viertelfinale" end)
    assert length(quarter_finale) == 4

    third_round = Enum.filter(matches, fn match -> match.group == "Achtelfinale" end)
    assert length(third_round) == 8

    second_round = Enum.filter(matches, fn match -> match.group == "2.Runde" end)
    assert length(second_round) == 16

    first_round = Enum.filter(matches, fn match -> match.group == "1.Runde" end)
    assert length(first_round) == 32
  end

  test "scraping current complete competition of Champions League" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/championsleague_current_2018_finished.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :championsLeague
      })

    Logger.debug(fn ->
      "pokal matches: #{inspect(matches)}"
    end)

    assert description == "KO-Runde 18/19"
    assert length(matches) == 29
    assert season == 2018

    finale = Enum.filter(matches, fn match -> match.group == "Finale" end)
    assert length(finale) == 1

    half_finale_second =
      Enum.filter(matches, fn match -> match.group == "Halbfinale - Rückspiele" end)

    assert length(half_finale_second) == 2

    half_finale_first =
      Enum.filter(matches, fn match -> match.group == "Halbfinale - Hinspiele" end)

    assert length(half_finale_first) == 2

    quarter_finale_2 =
      Enum.filter(matches, fn match -> match.group == "Viertelfinale - Rückspiele" end)

    assert length(quarter_finale_2) == 4

    quarter_finale_1 =
      Enum.filter(matches, fn match -> match.group == "Viertelfinale - Hinspiele" end)

    assert length(quarter_finale_1) == 4

    third_round_2 =
      Enum.filter(matches, fn match -> match.group == "Achtelfinale - Rückspiele" end)

    assert length(third_round_2) == 8

    third_round_1 =
      Enum.filter(matches, fn match -> match.group == "Achtelfinale - Hinspiele" end)

    assert length(third_round_1) == 8
  end

  test "scraping current upcoming competition of Champions League" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/championsleague_current_2019_upcoming.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :championsLeague
      })

    assert description == nil
    assert length(matches) == 0
    assert season == 2019
  end

  test "scraping current upcoming first matchday of Champions League" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/championsleague_current_2019_matchday1_upcoming.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :championsLeague
      })

    assert description == "Gruppenphase 1. Spieltag"
    assert length(matches) == 16
    assert season == 2019
    assert number == 1
  end

  test "scraping current complete competition of Europa League" do
    {:ok, result} =
      File.read(
        "./test/simplefootball_web_web/resources/tm/europaleague_current_2018_finished.html"
      )

    %{description: description, number: number, season: season, matches: matches} =
      TMParser.scrape_current_matchday(result, %{
        competition_type: :europaLeague
      })

    Logger.debug(fn ->
      "pokal matches: #{inspect(matches)}"
    end)

    assert description == "KO-Runde 18/19"
    assert length(matches) == 61
    assert season == 2018

    finale = Enum.filter(matches, fn match -> match.group == "Finale" end)
    assert length(finale) == 1

    half_finale_second =
      Enum.filter(matches, fn match -> match.group == "Halbfinale - Rückspiele" end)

    assert length(half_finale_second) == 2

    half_finale_first =
      Enum.filter(matches, fn match -> match.group == "Halbfinale - Hinspiele" end)

    assert length(half_finale_first) == 2

    quarter_finale_2 =
      Enum.filter(matches, fn match -> match.group == "Viertelfinale - Rückspiele" end)

    assert length(quarter_finale_2) == 4

    quarter_finale_1 =
      Enum.filter(matches, fn match -> match.group == "Viertelfinale - Hinspiele" end)

    assert length(quarter_finale_1) == 4

    third_round_2 =
      Enum.filter(matches, fn match -> match.group == "Achtelfinale - Rückspiele" end)

    assert length(third_round_2) == 8

    third_round_1 =
      Enum.filter(matches, fn match -> match.group == "Achtelfinale - Hinspiele" end)

    assert length(third_round_1) == 8

    second_round_2 =
      Enum.filter(matches, fn match -> match.group == "Zwischenrunde - Rückspiele" end)

    assert length(second_round_2) == 16

    second_round_1 =
      Enum.filter(matches, fn match -> match.group == "Zwischenrunde - Hinspiele" end)

    assert length(second_round_1) == 16
  end

  def is_upcoming_match(match) do
    assert match.is_started == false
    assert match.is_running == false
    assert match.result == "-:-"
    assert match.is_penalty == false
    assert match.is_extra_time == false
  end

  def is_augsburg(team) do
    assert team.name == "FC Augsburg"
    assert team.tm_identifier == "167"
  end

  def is_bauern(team) do
    assert team.name == "Bayern München"
    assert team.tm_identifier == "27"
  end

  def is_hertha(team) do
    assert team.name == "Hertha BSC"
    assert team.tm_identifier == "44"
  end

  def is_dortmund(team) do
    assert team.name == "Bor. Dortmund"
    assert team.tm_identifier == "16"
  end

  def is_bremen(team) do
    assert team.name == "Werder Bremen"
    assert team.tm_identifier == "86"
  end

  def is_gladbach(team) do
    assert team.name == "Bor. M'gladbach"
    assert team.tm_identifier == "18"
  end

  def is_scheisse(team) do
    assert team.name == "FC Schalke 04"
    assert team.tm_identifier == "33"
  end

  def is_leverkusen(team) do
    assert team.name == "Bay. Leverkusen"
    assert team.tm_identifier == "15"
  end

  def is_leipzig(team) do
    assert team.name == "RB Leipzig"
    assert team.tm_identifier == "23826"
  end

  def is_hoffenheim(team) do
    assert team.name == "TSG Hoffenheim"
    assert team.tm_identifier == "533"
  end

  def is_wolfsburg(team) do
    assert team.name == "VfL Wolfsburg"
    assert team.tm_identifier == "82"
  end

  def is_mainz(team) do
    assert team.name == "1.FSV Mainz 05"
    assert team.tm_identifier == "39"
  end

  def is_freiburg(team) do
    assert team.name == "SC Freiburg"
    assert team.tm_identifier == "60"
  end

  def is_frankfurt(team) do
    assert team.name == "E. Frankfurt"
    assert team.tm_identifier == "24"
  end

  def is_duesseldorf(team) do
    assert team.name == "F. Düsseldorf"
    assert team.tm_identifier == "38"
  end

  def is_koeln(team) do
    assert team.name == "1.FC Köln"
    assert team.tm_identifier == "3"
  end

  def is_paderborn(team) do
    assert team.name == "SC Paderborn"
    assert team.tm_identifier == "127"
  end

  def is_union(team) do
    assert team.name == "Union Berlin"
    assert team.tm_identifier == "89"
  end
end
