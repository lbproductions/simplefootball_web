defmodule SimplefootballWebWeb.CompetitionViewTest do
  use SimplefootballWebWeb.ConnCase, async: true

  alias SimplefootballWeb.Competition
  alias SimplefootballWebWeb.CompetitionView

  test "render a competition" do
    competition = %Competition{
      name: "1. Bundesliga",
      icon_url: "URL",
      id: 1,
      competition_type: "bundesliga"
    }

    result = CompetitionView.renderCompetition(competition)

    assert result == %{
             name: "1. Bundesliga",
             iconUrl: "URL",
             competitionType: "bundesliga"
           }
  end

  test "render a list of competitions" do
    competition1 = %Competition{
      name: "1. Bundesliga",
      icon_url: "URL",
      id: 1,
      competition_type: "bundesliga"
    }

    competition2 = %Competition{
      name: "2. Bundesliga",
      icon_url: "URL2",
      id: 2,
      competition_type: "bundesliga2"
    }

    result = CompetitionView.renderList([competition1, competition2])

    assert result == [
             %{
               name: "1. Bundesliga",
               iconUrl: "URL",
               competitionType: "bundesliga"
             },
             %{
               name: "2. Bundesliga",
               iconUrl: "URL2",
               competitionType: "bundesliga2"
             }
           ]
  end
end
