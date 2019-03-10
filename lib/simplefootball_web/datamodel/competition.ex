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

  schema "competitions" do
    field(:competition_type, CompetitionType)
    field(:name, :string)
    field(:icon_url, :string)

    has_many(:seasons, Season)
  end
end
