defmodule SimplefootballWeb.Season do
  use Ecto.Schema

  alias SimplefootballWeb.{Competition, Matchday}

  schema "seasons" do
    field(:year, :integer)
    field(:title, :string)

    belongs_to(:competition, Competition)
    has_many(:matchdays, Matchday)
  end
end
