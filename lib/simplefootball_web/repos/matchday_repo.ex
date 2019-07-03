defmodule SimplefootballWeb.MatchdayRepo do
  import Ecto.{Query, Changeset}, warn: false

  alias SimplefootballWeb.{Repo, Matchday}

  require Logger

  def matchday_by(season_id: season_id, number: number) do
    Matchday
    |> Repo.get_by(season_id: season_id, number: number)
  end

  def update_or_create_matchday_by(season_id: season_id, number: number, changeset: changeset) do
    case matchday_by(season_id: season_id, number: number) do
      nil -> %Matchday{season_id: season_id, number: number}
      matchday -> matchday
    end
    |> Matchday.changeset(changeset)
    |> Repo.insert_or_update()
  end

  def update_current_matchday(current_matchday, season) do
    {changed_number_of_matchdays, _data} =
      from(m in Matchday,
        where:
          m.is_current_matchday == true and m.season_id == ^season.id and
            m.id != ^current_matchday.id,
        update: [set: [is_current_matchday: false]]
      )
      |> Repo.update_all([])

    %{
      changed_number_of_matchdays: changed_number_of_matchdays
    }
  end
end
