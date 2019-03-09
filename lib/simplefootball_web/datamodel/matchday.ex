defmodule SimplefootballWeb.Matchday do
  use Ecto.Schema

  alias SimplefootballWeb.{Match, Season}

  @primary_key {:id, :binary_id, [autogenerated: false]}
  schema "matchdays" do
    field(:number, :integer)
    field(:description, :string)

    has_many(:matches, Match)
    belongs_to(:season, Season)
  end
end
