defmodule SimplefootballWeb.Competition do
    use Ecto.Schema
    import EctoEnum

    alias SimplefootballWeb.{Season}
    
    defenum CompetitionType, :competitionType, [:bundesliga, :bundesliga2, :regionalligaWest, :dfbPokal, :championsLeague, :europaLeague, :premierLeague, :laLiga, :serieA, :ligue1]
  
    @primary_key {:id, :binary_id, [autogenerated: false]}
    schema "competitions" do
        field(:competitionType, CompetitionType)
        field(:name, :string)
        field(:iconUrl, :string)

        has_many(:seasons, Season)
    end
end