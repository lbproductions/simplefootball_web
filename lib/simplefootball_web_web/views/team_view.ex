defmodule SimplefootballWebWeb.TeamView do
  use SimplefootballWebWeb, :view

  # alias SimplefootballWebWeb.MatchView

  def render_list(teams) do
    Enum.map(teams, fn team -> render_team(team) end)
  end

  def render_team(team) do
    %{
      name: team.name,
      abbreviation: team.abbreviation
    }
    |> Helpers.drop_nil()
  end
end
