defmodule SimplefootballWebWeb.MatchView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.TeamView

  def render_list(matches) do
    Enum.map(matches, fn match -> render_match(match) end)
  end

  def render_match(match) do
    %{
      date: DateTime.to_string(match.date),
      result: match.result,
      afterPenalties: match.after_penalties,
      extraTime: match.extra_time,
      homeTeam: include_team(match.home_team),
      awayTeam: include_team(match.away_team)
    }
    |> Helpers.drop_nil()
  end

  def include_team(team) do
    if team != nil && Ecto.assoc_loaded?(team) do
      TeamView.render_team(team)
    else
      nil
    end
  end
end
