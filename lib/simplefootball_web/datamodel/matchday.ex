defmodule SimplefootballWeb.Matchday do
  use Ecto.Schema

  alias SimplefootballWeb.{Match, Season}

  schema "matchdays" do
    field(:number, :integer)
    field(:description, :string)
    field(:is_current_matchday, :boolean)

    has_many(:matches, Match)
    belongs_to(:season, Season)
  end
end
