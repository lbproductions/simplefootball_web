import EctoEnum

defenum(CompetitionType, :competitionType, [
  :bundesliga,
  :bundesliga2,
  :regionalligaWest,
  :dfbPokal,
  :championsLeague,
  :europaLeague,
  :premierLeague,
  :laLiga,
  :serieA,
  :ligue1
])

defmodule SimplefootballWeb.Competition do
  use Ecto.Schema

  alias SimplefootballWeb.{Season}

  @competition_types [
    :bundesliga,
    :bundesliga2,
    :regionalligaWest,
    :dfbPokal,
    :championsLeague,
    :europaLeague,
    :premierLeague,
    :laLiga,
    :serieA,
    :ligue1
  ]

  def competition_types() do
    @competition_types
  end

  def competition_rounds(competition_type) do
    case competition_type do
      :dfbPokal -> ["1.Runde", "2.Runde", "Achtelfinale", "Viertelfinale", "Halbfinale", "Finale"]
      true -> []
    end
  end

  schema "competitions" do
    field(:competition_type, CompetitionType)
    field(:name, :string)
    field(:icon_url, :string)

    has_many(:seasons, Season)
  end
end
