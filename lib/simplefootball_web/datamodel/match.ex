defmodule SimplefootballWeb.Match do
    use Ecto.Schema

    alias SimplefootballWeb.{MatchEvent, Team, Lineup, Matchday}
  
    @primary_key {:id, :binary_id, [autogenerated: false]}
    schema "matches" do
        field(:date, :date)
        field(:result, :string)
        field(:afterPenalties, :boolean, default: false)
        field(:extraTime, :boolean, default: false)
        field(:tmIdentifier, :string)

        has_many(:matchEvents, MatchEvent)
        belongs_to(:homeTeam, Team)
        belongs_to(:awayTeam, Team)
        belongs_to(:matchday, Matchday)
        has_one(:homeLineup, Lineup)
        has_one(:awayLineup, Lineup)
    end
end