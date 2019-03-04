defmodule SimplefootballWebWeb.TeamViewTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.Team
  alias SimplefootballWebWeb.TeamView

  test "render a team" do
    team = %Team{
      name: "Borussia Dortmund",
      abbreviation: "BVB"
    }

    result = TeamView.renderTeam(team)

    assert result == %{
             name: "Borussia Dortmund",
             abbreviation: "BVB"
           }
  end

  test "render a list of teams" do
    team1 = %Team{
      name: "Borussia Dortmund",
      abbreviation: "BVB"
    }

    team2 = %Team{
      name: "Bayer Leverkusen",
      abbreviation: "B04"
    }

    result = TeamView.renderList([team1, team2])

    assert result == [
             %{
               name: "Borussia Dortmund",
               abbreviation: "BVB"
             },
             %{
               name: "Bayer Leverkusen",
               abbreviation: "B04"
             }
           ]
  end
end
