defmodule SimplefootballWebWeb.MatchdayViewTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.{Matchday, Match}
  alias SimplefootballWebWeb.MatchdayView

  test "render a matchday without a match" do
    matchday = %Matchday{
      description: "1. Spieltag",
      number: 1,
      is_current_matchday: true
    }

    result = MatchdayView.renderMatchday(matchday)

    assert result == %{
             description: "1. Spieltag",
             number: 1,
             isCurrentMatchday: true
           }
  end

  test "render a matchday with matches" do
    date = DateTime.truncate(DateTime.utc_now(), :second)

    matchday = %Matchday{
      description: "1. Spieltag",
      number: 1,
      is_current_matchday: true,
      matches: [
        %Match{
          date: date,
          result: "2:1",
          after_penalties: false,
          extra_time: false
        },
        %Match{
          date: date,
          result: "2:2",
          after_penalties: true,
          extra_time: true
        }
      ]
    }

    result = MatchdayView.renderMatchday(matchday)

    assert result == %{
             description: "1. Spieltag",
             number: 1,
             isCurrentMatchday: true,
             matches: [
               %{
                 date: DateTime.to_string(date),
                 result: "2:1",
                 afterPenalties: false,
                 extraTime: false
               },
               %{
                 date: DateTime.to_string(date),
                 result: "2:2",
                 afterPenalties: true,
                 extraTime: true
               }
             ]
           }
  end

  test "render a list of matchdays" do
    matchday1 = %Matchday{
      description: "1. Spieltag",
      number: 1,
      is_current_matchday: true
    }

    matchday2 = %Matchday{
      description: "2. Spieltag",
      number: 2,
      is_current_matchday: false
    }

    result = MatchdayView.renderList([matchday1, matchday2])

    assert result == [
             %{
               description: "1. Spieltag",
               number: 1,
               isCurrentMatchday: true
             },
             %{
               description: "2. Spieltag",
               number: 2,
               isCurrentMatchday: false
             }
           ]
  end
end
