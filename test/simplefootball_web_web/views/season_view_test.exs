defmodule SimplefootballWebWeb.SeasonViewTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.Season
  alias SimplefootballWebWeb.SeasonView

  test "render a season without a matchday" do
    season = %Season{
      year: 2018
    }

    result = SeasonView.renderSeason(season)

    assert result == %{
             year: 2018
           }
  end

  test "render a season with matchdays" do
    season = %Season{
      year: 2018,
      matchdays: [
        %{
          description: "1. Spieltag",
          number: 1,
          is_current_matchday: true
        },
        %{
          description: "2. Spieltag",
          number: 2,
          is_current_matchday: false
        }
      ]
    }

    result = SeasonView.renderSeason(season)

    assert result == %{
             year: 2018,
             matchdays: [
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
           }
  end

  test "render a list of seasons" do
    season1 = %Season{
      year: 2017
    }

    season2 = %Season{
      year: 2018
    }

    result = SeasonView.renderList([season1, season2])

    assert result == [
             %{
               year: 2017
             },
             %{
               year: 2018
             }
           ]
  end
end
