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
      away_team: away_team,
      stadium: stadium,
      referee: referee,
      lineups: lineups,
      events: events,
      minute: minute
    } = TMMatchDetailsParser.scrape_live_match_details(result, '')

    assert result == "2:1"
    assert is_extra_time == false
    assert is_penalties == false
    assert DateTime.to_string(date) == "2018-12-21 19:30:00Z"
    assert home_team.name == "Borussia Dortmund"
    assert home_team.tm_identifier == "16"
    assert away_team.name == "Borussia Mönchengladbach"
    assert away_team.tm_identifier == "18"
    assert stadium.name == "SIGNAL IDUNA PARK"
    assert stadium.number_of_spectators == 81365
    assert referee.name == "Felix Zwayer"
    assert referee.href == "/felix-zwayer/profil/schiedsrichter/124"

    assert lineups == nil
    assert events == nil
    assert minute == nil
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
      away_team: away_team,
      stadium: stadium,
      referee: referee,
      events: events
    } = TMMatchDetailsParser.scrape_report_match_details(result, '')

    assert result == "5:1"
    assert is_extra_time == false
    assert is_penalties == false
    assert DateTime.to_string(date) == "2019-08-17 13:30:00Z"
    assert home_team.name == "Borussia Dortmund"
    assert home_team.tm_identifier == "16"
    assert away_team.name == "FC Augsburg"
    assert away_team.tm_identifier == "167"
    assert stadium.name == "SIGNAL IDUNA PARK"
    assert stadium.number_of_spectators == 81365
    assert referee.name == "Frank Willenborg"
    assert referee.href == "/frank-willenborg/profil/schiedsrichter/121"

    assert length(events.goals) == 6

    Logger.debug(fn ->
      "events.goals: #{inspect(events.goals)}"
    end)
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
      away_team: away_team,
      stadium: stadium,
      referee: referee
    } = TMMatchDetailsParser.scrape_report_match_details(result, '')

    assert result == "4:1"
    assert is_extra_time == true
    assert is_penalties == false
    assert DateTime.to_string(date) == "2020-02-27 17:55:00Z"
    assert home_team.name == "Istanbul Basaksehir FK"
    assert home_team.tm_identifier == "6890"
    assert away_team.name == "Sporting Lissabon"
    assert away_team.tm_identifier == "336"
    assert stadium.name == "Başakşehir Fatih Terim"
    assert stadium.number_of_spectators == nil
    assert referee.name == "Antonio Miguel Matéu Lahoz"
    assert referee.href == "/antonio-miguel-mateu-lahoz/profil/schiedsrichter/1525"
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
      away_team: away_team,
      stadium: stadium,
      referee: referee,
      lineups: lineups,
      events: events,
      minute: minute
    } = TMMatchDetailsParser.scrape_live_match_details(result, '3292014')

    assert result == "0:1"
    assert is_extra_time == nil
    assert is_penalties == nil
    assert DateTime.to_string(date) == "2020-02-27 20:00:00Z"
    assert home_team.name == "FC Arsenal"
    assert home_team.tm_identifier == "11"
    assert away_team.name == "Olympiakos Piräus"
    assert away_team.tm_identifier == "683"
    assert stadium.name == "Emirates Stadium"
    assert stadium.number_of_spectators == nil
    assert referee.name == "Davide Massa"
    assert referee.href == "/davide-massa/profil/schiedsrichter/2640"

    assert length(lineups.home.start) == 11
    assert length(lineups.home.bench) == 7
    assert length(lineups.away.start) == 11
    assert length(lineups.away.bench) == 7

    ceballos = Enum.at(lineups.home.start, 0)
    assert ceballos.name == "Dani Ceballos"
    assert ceballos.position == "Defensive Midfielder"
    assert ceballos.shirt_number == 8
    assert ceballos.tm_identifier == 319_745

    willock = Enum.at(lineups.home.bench, 0)
    assert willock.name == "J. Willock"
    assert willock.position == nil
    assert willock.shirt_number == 28
    assert willock.tm_identifier == 340_329

    valbuena = Enum.at(lineups.away.start, 0)
    assert valbuena.name == "M. Valbuena"
    assert valbuena.position == "Striker"
    assert valbuena.shirt_number == 28
    assert valbuena.tm_identifier == 40687

    torosidis = Enum.at(lineups.away.bench, 0)
    assert torosidis.name == "V. Torosidis"
    assert torosidis.position == nil
    assert torosidis.shirt_number == 35
    assert torosidis.tm_identifier == 24977

    assert length(events.goals) == 1
    goal = Enum.at(events.goals, 0)
    assert goal.minute == 53
    assert goal.is_home == false
    assert goal.type == 200
    assert goal.scorer.name == "P. Cissé"
    assert goal.scorer.tm_identifier == 364_234
    assert goal.assist.name == "M. Valbuena"
    assert goal.assist.tm_identifier == 40687

    assert length(events.cards) == 2
    card = Enum.at(events.cards, 0)
    assert card.is_home == false
    assert card.minute == 20
    assert card.player.name == "O. Ba"
    assert card.player.tm_identifier == 520_815
    assert card.type == 301

    card = Enum.at(events.cards, 1)
    assert card.is_home == false
    assert card.minute == 58
    assert card.player.name == "M. Camara"
    assert card.player.tm_identifier == 481_173
    assert card.type == 301

    assert length(events.subs) == 4
    sub = Enum.at(events.subs, 0)
    assert sub.is_home == true
    assert sub.minute == 72
    assert sub.player_off.name == "Dani Ceballos"
    assert sub.player_off.tm_identifier == 319_745
    assert sub.player_on.name == "L. Torreira"
    assert sub.player_on.tm_identifier == 318_077

    assert minute == 92
  end
end
