defmodule SimplefootballWeb.Season do
  use Ecto.Schema
  import Ecto.Changeset

  alias SimplefootballWeb.{Competition, Matchday}

  schema "seasons" do
    field(:year, :integer)
    field(:title, :string)

    belongs_to(:competition, Competition)
    has_many(:matchdays, Matchday)
  end

  def changeset(season, attrs) do
    season
    |> cast(attrs, [:year, :title])
  end
end
