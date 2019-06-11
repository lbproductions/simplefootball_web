defmodule SimplefootballWeb.Matchday do
  use Ecto.Schema
  import Ecto.Changeset

  alias SimplefootballWeb.{Match, Season}

  schema "matchdays" do
    field(:number, :integer)
    field(:description, :string)
    field(:is_current_matchday, :boolean)

    has_many(:matches, Match)
    belongs_to(:season, Season)
  end

  def changeset(matchday, attrs) do
    matchday
    |> cast(attrs, [
      :number,
      :description,
      :is_current_matchday,
      :season_id
    ])
  end
end
