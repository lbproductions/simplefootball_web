defmodule SimplefootballWebWeb.MatchViewTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.{Match, Team}
  alias SimplefootballWebWeb.MatchView

  test "render a match without teams" do
    date = DateTime.truncate(DateTime.utc_now(), :second)

    match = %Match{
      date: date,
      result: "2:1",
      after_penalties: false,
      extra_time: false
    }

    result = MatchView.render_match(match)

    assert result == %{
             date: DateTime.to_string(date),
             result: "2:1",
             afterPenalties: false,
             extraTime: false,
             isRunning: false,
             isStarted: false
           }
  end

  test "render a match with teams" do
    date = DateTime.truncate(DateTime.utc_now(), :second)

    match = %Match{
      date: date,
      result: "2:1",
      after_penalties: false,
      extra_time: false,
      home_team: %Team{
        name: "Borussia Dortmund",
        abbreviation: "BVB"
      },
      away_team: %Team{
        name: "Bayer Leverkusen",
        abbreviation: "B04"
      }
    }

    result = MatchView.render_match(match)

    assert result == %{
             date: DateTime.to_string(date),
             result: "2:1",
             afterPenalties: false,
             extraTime: false,
             homeTeam: %{
               name: "Borussia Dortmund",
               abbreviation: "BVB"
             },
             awayTeam: %{
               name: "Bayer Leverkusen",
               abbreviation: "B04"
             },
             isRunning: false,
             isStarted: false
           }
  end

  test "render a list of matches" do
    date = DateTime.truncate(DateTime.utc_now(), :second)

    match1 = %Match{
      date: date,
      result: "2:1",
      after_penalties: false,
      extra_time: false,
      is_running: true,
      is_started: true
    }

    match2 = %Match{
      date: date,
      result: "2:2",
      after_penalties: true,
      extra_time: true
    }

    result = MatchView.render_list([match1, match2])

    assert result == [
             %{
               date: DateTime.to_string(date),
               result: "2:1",
               afterPenalties: false,
               extraTime: false,
               isRunning: true,
               isStarted: true
             },
             %{
               date: DateTime.to_string(date),
               result: "2:2",
               afterPenalties: true,
               extraTime: true,
               isRunning: false,
               isStarted: false
             }
           ]
  end
end
