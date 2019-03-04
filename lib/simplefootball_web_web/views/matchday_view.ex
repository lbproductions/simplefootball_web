defmodule SimplefootballWebWeb.MatchdayView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.MatchView

  def renderList(matchdays) do
    Enum.map(matchdays, fn matchday -> renderMatchday(matchday) end)
  end

  def renderMatchday(matchday) do
    %{
      number: matchday.number,
      description: matchday.description,
      isCurrentMatchday: matchday.is_current_matchday,
      matches: includeMatches(matchday)
    }
    |> Helpers.drop_nil()
  end

  def includeMatches(matchday) do
    if Map.has_key?(matchday, :matches) && Ecto.assoc_loaded?(matchday.matches) do
      MatchView.renderList(matchday.matches)
    else
      nil
    end
  end
end
