defmodule SimplefootballWebWeb.MatchView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.TeamView

  def renderList(matches) do
    Enum.map(matches, fn match -> renderMatch(match) end)
  end

  def renderMatch(match) do
    %{
      date: DateTime.to_string(match.date),
      result: match.result,
      afterPenalties: match.after_penalties,
      extraTime: match.extra_time,
      homeTeam: includeTeam(match.home_team),
      awayTeam: includeTeam(match.away_team)
    }
    |> Helpers.drop_nil()
  end

  def includeTeam(team) do
    if team != nil && Ecto.assoc_loaded?(team) do
      TeamView.renderTeam(team)
    else
      nil
    end
  end
end
