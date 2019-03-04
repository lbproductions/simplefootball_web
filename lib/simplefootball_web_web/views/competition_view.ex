defmodule SimplefootballWebWeb.CompetitionView do
  use SimplefootballWebWeb, :view

  alias SimplefootballWebWeb.SeasonView

  def renderList(competitions) do
    Enum.map(competitions, fn competition -> renderCompetition(competition) end)
  end

  def renderCompetition(competition) do
    %{
      name: competition.name,
      iconUrl: competition.icon_url,
      competitionType: competition.competition_type,
      seasons: includeSeasons(competition)
    }
    |> Helpers.drop_nil()
  end

  def includeSeasons(competition) do
    if Map.has_key?(competition, :seasons) && Ecto.assoc_loaded?(competition.seasons) do
      SeasonView.renderList(competition.seasons)
    else
      nil
    end
  end
end
