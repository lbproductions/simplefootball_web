defmodule SimplefootballWebWeb.CompetitionView do
  use SimplefootballWebWeb, :view

  def renderList(competitions) do
    Enum.map(competitions, fn competition -> renderCompetition(competition) end)
  end

  def renderCompetition(competition) do
    %{
      name: competition.name,
      iconUrl: competition.icon_url,
      id: competition.id,
      competitionType: competition.competition_type
    }
  end
end
