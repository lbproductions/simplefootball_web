defmodule SimplefootballWebWeb.SeasonView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.MatchdayView

  def render_list(seasons) do
    Enum.map(seasons, fn season -> render_season(season) end)
  end

  def render_season(season) do
    %{
      year: season.year,
      title: season.title,
      matchdays: include_matchdays(season)
    }
    |> Helpers.drop_nil()
  end

  def include_matchdays(season) do
    if Map.has_key?(season, :matchdays) && Ecto.assoc_loaded?(season.matchdays) do
      MatchdayView.render_list(season.matchdays)
    else
      nil
    end
  end
end
