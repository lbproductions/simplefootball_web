defmodule SimplefootballWeb.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  import EctoEnum
    
    defenum CompetitionType, :competitionType, [:bundesliga, :bundesliga2, :regionalligaWest, :dfbPokal, :championsLeague, :europaLeague, :premierLeague, :laLiga, :serieA, :ligue1]
    defenum MatchEventType, :matchEventType, [:goal, :substitution, :card]

    def change do
      CompetitionType.create_type
      MatchEventType.create_type

      create table(:competitions) do
        add :competition_type, CompetitionType.type()
        add :name, :string
        add :icon_url, :string
      end

      create table(:seasons) do
        add :year, :integer
        add :competition_id, references(:competitions)
      end

      create table(:matchdays) do
        add :number, :integer
        add :description, :string
        add :season_id, references(:seasons)
      end

      create table(:teams) do
        add :name, :string
        add :abbreviation, :string
        add :tm_identifier, :string
        add :alternative_names, {:array, :string}
      end

      create table(:matches) do
        add :date, :date
        add :result, :string
        add :after_penalties, :boolean
        add :extraTime, :boolean
        add :tm_identifier, :string
        add :home_team_id, references(:teams)
        add :away_team_id, references(:teams)
        add :matchday_id, references(:matchdays)
      end

      create table(:players) do
        add :name, :string
        add :shirt_number, :string
        add :tm_identifier, :string
      end

      create table(:lineups) do
        add :team_id, references(:teams)
        add :match_id, references(:matches)
      end

      create table(:lineup_players) do
        add :player_id, references(:players)
        add :lineup_id, references(:lineups)
      end
    end
end
