defmodule SimplefootballWeb.Repo.Migrations.CreateApp do
    use Ecto.Migration

    import EctoEnum
  
    def change do
      CompetitionType.create_type()

      create table(:competitions) do
        add :competitionType, CompetitionType.type()
        add :name, :string
        add :iconUrl, :string
      end

      create table(:seasons) do
        add :year, :integer
        add :competition_id, references(:competition)
      end

      create table(:matchdays) do
        add :number, :integer
        add :description, :string
        add :season_id, references(:season)
      end

      create table(:matches) do
        add :date, :date
        add :result, :string
        add :afterPenalties, :boolean
        add :extraTime, :boolean
        add :tmIdentifier, :string
        add :home_team_id, references(:homeTeam)
        add :away_team_id, references(:awayTeam)
        add :matchday_id, references(:matchday)
      end

      create table(:teams) do
        add :name, :string
        add :abbreviation, :string
        add :tmIdentifier, :string
        add :alternativeNames, {:array, :string}
      end

      create table(:players) do
        add :name, :string
        add :shirtNumber, :string
        add :tmIdentifier, :string
      end

      create table(:lineup) do
        add :team_id, references(:team)
        add :match_id, references(:match)
      end

      create table(:lineup_players) do
        add :player_id, references(:player)
        add :lineup_id, references(:lineup)
      end
    end
  end