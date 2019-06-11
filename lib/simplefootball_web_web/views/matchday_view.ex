defmodule SimplefootballWebWeb.MatchdayView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.MatchView

  def render_list(matchdays) do
    Enum.map(matchdays, fn matchday -> render_matchday(matchday) end)
  end

  def render_matchday(matchday) do
    %{
      number: matchday.number,
      description: matchday.description,
      isCurrentMatchday: matchday.is_current_matchday,
      matches: include_matches(matchday)
    }
    |> Helpers.drop_nil()
  end

  def include_matches(matchday) do
    if Map.has_key?(matchday, :matches) && Ecto.assoc_loaded?(matchday.matches) do
      MatchView.render_list(matchday.matches)
    else
      nil
    end
  end
end
