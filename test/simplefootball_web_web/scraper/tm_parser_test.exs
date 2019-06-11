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
    assert match.match.result == "1:3"
    assert match.match.tm_identifier == "3058569"
    assert DateTime.to_string(match.match.date) == "2019-01-18 19:30:00Z"

    match = Enum.at(matches, 1)
    assert match.home_team.name == "FC Augsburg"
    assert match.home_team.abbreviation == "FCA"
    assert match.home_team.tm_identifier == "167"
    assert match.away_team.name == "F. Düsseldorf"
    assert match.away_team.abbreviation == "F95"
    assert match.away_team.tm_identifier == "38"
    assert match.match.result == "1:2"
    assert match.match.tm_identifier == "3058574"
    assert DateTime.to_string(match.match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 2)
    assert match.home_team.name == "E. Frankfurt"
    assert match.home_team.abbreviation == "SGE"
    assert match.home_team.tm_identifier == "24"
    assert match.away_team.name == "SC Freiburg"
    assert match.away_team.abbreviation == "SC"
    assert match.away_team.tm_identifier == "60"
    assert match.match.result == "3:1"
    assert match.match.tm_identifier == "3058573"
    assert DateTime.to_string(match.match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 3)
    assert match.home_team.name == "Bay. Leverkusen"
    assert match.home_team.abbreviation == "Bayer"
    assert match.home_team.tm_identifier == "15"
    assert match.away_team.name == "Bor. M'gladbach"
    assert match.away_team.abbreviation == "BMG"
    assert match.away_team.tm_identifier == "18"
    assert match.match.result == "0:1"
    assert match.match.tm_identifier == "3058570"
    assert DateTime.to_string(match.match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 4)
    assert match.home_team.name == "Hannover 96"
    assert match.home_team.abbreviation == "H96"
    assert match.home_team.tm_identifier == "42"
    assert match.away_team.name == "Werder Bremen"
    assert match.away_team.abbreviation == "Werder"
    assert match.away_team.tm_identifier == "86"
    assert match.match.result == "0:1"
    assert match.match.tm_identifier == "3058575"
    assert DateTime.to_string(match.match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 5)
    assert match.home_team.name == "VfB Stuttgart"
    assert match.home_team.abbreviation == "VfB"
    assert match.home_team.tm_identifier == "79"
    assert match.away_team.name == "1.FSV Mainz 05"
    assert match.away_team.abbreviation == "Mainz"
    assert match.away_team.tm_identifier == "39"
    assert match.match.result == "2:3"
    assert match.match.tm_identifier == "3058572"
    assert DateTime.to_string(match.match.date) == "2019-01-19 14:30:00Z"

    match = Enum.at(matches, 6)
    assert match.home_team.name == "RB Leipzig"
    assert match.home_team.abbreviation == "RBL"
    assert match.home_team.tm_identifier == "23826"
    assert match.away_team.name == "Bor. Dortmund"
    assert match.away_team.abbreviation == "BVB"
    assert match.away_team.tm_identifier == "16"
    assert match.match.result == "0:1"
    assert match.match.tm_identifier == "3058571"
    assert DateTime.to_string(match.match.date) == "2019-01-19 17:30:00Z"

    match = Enum.at(matches, 7)
    assert match.home_team.name == "1.FC Nürnberg"
    assert match.home_team.abbreviation == "1.FCN"
    assert match.home_team.tm_identifier == "4"
    assert match.away_team.name == "Hertha BSC"
    assert match.away_team.abbreviation == "Hertha"
    assert match.away_team.tm_identifier == "44"
    assert match.match.result == "1:3"
    assert match.match.tm_identifier == "3058576"
    assert DateTime.to_string(match.match.date) == "2019-01-20 14:30:00Z"

    match = Enum.at(matches, 8)
    assert match.home_team.name == "FC Schalke 04"
    assert match.home_team.abbreviation == "S04"
    assert match.home_team.tm_identifier == "33"
    assert match.away_team.name == "VfL Wolfsburg"
    assert match.away_team.abbreviation == "VfL"
    assert match.away_team.tm_identifier == "82"
    assert match.match.result == "2:1"
    assert match.match.tm_identifier == "3058568"
    assert DateTime.to_string(match.match.date) == "2019-01-20 17:00:00Z"
  end

  test "scraping an incomplete matchday" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/bundesliga_2018_25_incomplete.html")

    %{matches: matches} = TMParser.scrape_matchday(result)

    Logger.debug(fn ->
      "matches: #{inspect(matches)}"
    end)

    assert length(matches) == 9

    match = Enum.at(matches, 0)
    assert match.home_team.name == "Werder Bremen"
    assert match.home_team.abbreviation == "Werder"
    assert match.home_team.tm_identifier == "86"
    assert match.away_team.name == "FC Schalke 04"
    assert match.away_team.abbreviation == "S04"
    assert match.away_team.tm_identifier == "33"
    assert match.match.result == "4:2"
    assert match.match.tm_identifier == "3058643"
    assert DateTime.to_string(match.match.date) == "2019-03-08 19:30:00Z"

    match = Enum.at(matches, 1)
    assert match.home_team.name == "SC Freiburg"
    assert match.home_team.abbreviation == "SC"
    assert match.home_team.tm_identifier == "60"
    assert match.away_team.name == "Hertha BSC"
    assert match.away_team.abbreviation == "Hertha"
    assert match.away_team.tm_identifier == "44"
    assert match.match.result == "2:1"
    assert match.match.tm_identifier == "3058645"
    assert DateTime.to_string(match.match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 2)
    assert match.home_team.name == "RB Leipzig"
    assert match.home_team.abbreviation == "RBL"
    assert match.home_team.tm_identifier == "23826"
    assert match.away_team.name == "FC Augsburg"
    assert match.away_team.abbreviation == "FCA"
    assert match.away_team.tm_identifier == "167"
    assert match.match.result == "0:0"
    assert match.match.tm_identifier == "3058642"
    assert DateTime.to_string(match.match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 3)
    assert match.home_team.name == "Bayern München"
    assert match.home_team.abbreviation == "FCB"
    assert match.home_team.tm_identifier == "27"
    assert match.away_team.name == "VfL Wolfsburg"
    assert match.away_team.abbreviation == "VfL"
    assert match.away_team.tm_identifier == "82"
    assert match.match.result == "6:0"
    assert match.match.tm_identifier == "3058639"
    assert DateTime.to_string(match.match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 4)
    assert match.home_team.name == "Bor. Dortmund"
    assert match.home_team.abbreviation == "BVB"
    assert match.home_team.tm_identifier == "16"
    assert match.away_team.name == "VfB Stuttgart"
    assert match.away_team.abbreviation == "VfB"
    assert match.away_team.tm_identifier == "79"
    assert match.match.result == "3:1"
    assert match.match.tm_identifier == "3058641"
    assert DateTime.to_string(match.match.date) == "2019-03-09 14:30:00Z"

    match = Enum.at(matches, 5)
    assert match.home_team.name == "1.FSV Mainz 05"
    assert match.home_team.abbreviation == "Mainz"
    assert match.home_team.tm_identifier == "39"
    assert match.away_team.name == "Bor. M'gladbach"
    assert match.away_team.abbreviation == "BMG"
    assert match.away_team.tm_identifier == "18"
    assert match.match.result == "0:1"
    assert match.match.tm_identifier == "3058646"
    assert DateTime.to_string(match.match.date) == "2019-03-09 17:30:00Z"

    match = Enum.at(matches, 6)
    assert match.home_team.name == "TSG Hoffenheim"
    assert match.home_team.abbreviation == "1899"
    assert match.home_team.tm_identifier == "533"
    assert match.away_team.name == "1.FC Nürnberg"
    assert match.away_team.abbreviation == "1.FCN"
    assert match.away_team.tm_identifier == "4"
    assert match.match.result == "2:1"
    assert match.match.tm_identifier == "3058640"
    assert DateTime.to_string(match.match.date) == "2019-03-10 14:30:00Z"

    match = Enum.at(matches, 7)
    assert match.home_team.name == "Hannover 96"
    assert match.home_team.abbreviation == "H96"
    assert match.home_team.tm_identifier == "42"
    assert match.away_team.name == "Bay. Leverkusen"
    assert match.away_team.abbreviation == "Bayer"
    assert match.away_team.tm_identifier == "15"
    assert match.match.result == "-:-"
    assert match.match.tm_identifier == "3058644"
    assert DateTime.to_string(match.match.date) == "2019-03-10 17:00:00Z"

    match = Enum.at(matches, 8)
    assert match.home_team.name == "F. Düsseldorf"
    assert match.home_team.abbreviation == "F95"
    assert match.home_team.tm_identifier == "38"
    assert match.away_team.name == "E. Frankfurt"
    assert match.away_team.abbreviation == "SGE"
    assert match.away_team.tm_identifier == "24"
    assert match.match.result == "-:-"
    assert match.match.tm_identifier == "3058647"
    assert DateTime.to_string(match.match.date) == "2019-03-11 19:30:00Z"
  end
end
