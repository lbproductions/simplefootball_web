defmodule SimplefootballWeb.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias SimplefootballWeb.{MatchEvent, Team, Lineup, Matchday}

  schema "matches" do
    field(:date, :utc_datetime)
    field(:result, :string)
    field(:after_penalties, :boolean, default: false)
    field(:extra_time, :boolean, default: false)
    field(:is_running, :boolean, default: false)
    field(:is_started, :boolean, default: false)
    field(:tm_identifier, :string)

    has_many(:match_events, MatchEvent)
    belongs_to(:home_team, Team)
    belongs_to(:away_team, Team)
    belongs_to(:matchday, Matchday)
    has_one(:home_lineup, Lineup)
    has_one(:away_lineup, Lineup)
  end

  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :date,
      :result,
      :after_penalties,
      :extra_time,
      :is_started,
      :is_running,
      :tm_identifier,
      :home_team_id,
      :away_team_id,
      :matchday_id
    ])
  end
end
