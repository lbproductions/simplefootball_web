defmodule SimplefootballWeb.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  import EctoEnum
    
    defenum CompetitionType, :competitionType, [:bundesliga, :bundesliga2, :regionalligaWest, :dfbPokal, :championsLeague, :europaLeague, :premierLeague, :laLiga, :serieA, :ligue1]
  
    def change do
      CompetitionType.create_type

      create table(:competitions) do
        add :competitionType, CompetitionType.type()
        add :name, :string
        add :iconUrl, :string
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
        add :tmIdentifier, :string
        add :alternativeNames, {:array, :string}
      end

      create table(:matches) do
        add :date, :date
        add :result, :string
        add :afterPenalties, :boolean
        add :extraTime, :boolean
        add :tmIdentifier, :string
        add :home_team_id, references(:teams)
        add :away_team_id, references(:teams)
        add :matchday_id, references(:matchdays)
      end

      create table(:players) do
        add :name, :string
        add :shirtNumber, :string
        add :tmIdentifier, :string
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
