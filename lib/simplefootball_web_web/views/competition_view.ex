defmodule SimplefootballWebWeb.CompetitionView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.SeasonView

  def render_list(competitions) do
    Enum.map(competitions, fn competition -> render_competition(competition) end)
  end

  def render_competition(competition) do
    %{
      name: competition.name,
      iconUrl: competition.icon_url,
      competitionType: competition.competition_type,
      seasons: include_seasons(competition)
    }
    |> Helpers.drop_nil()
  end

  def include_seasons(competition) do
    if Map.has_key?(competition, :seasons) && Ecto.assoc_loaded?(competition.seasons) do
      SeasonView.render_list(competition.seasons)
    else
      nil
    end
  end
end
