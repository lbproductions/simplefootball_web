defmodule SimplefootballWebWeb.TeamView do
  use SimplefootballWebWeb, :view

  # alias SimplefootballWebWeb.MatchView

  def renderList(teams) do
    Enum.map(teams, fn team -> renderTeam(team) end)
  end

  def renderTeam(team) do
    %{
      name: team.name,
      abbreviation: team.abbreviation
    }
    |> Helpers.drop_nil()
  end
end
