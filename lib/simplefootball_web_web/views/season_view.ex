defmodule SimplefootballWebWeb.SeasonView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.MatchdayView

  def renderList(seasons) do
    Enum.map(seasons, fn season -> renderSeason(season) end)
  end

  def renderSeason(season) do
    %{
      year: season.year,
      matchdays: includeMatchdays(season)
    }
    |> Helpers.drop_nil()
  end

  def includeMatchdays(season) do
    if Map.has_key?(season, :matchdays) && Ecto.assoc_loaded?(season.matchdays) do
      MatchdayView.renderList(season.matchdays)
    else
      nil
    end
  end
end
