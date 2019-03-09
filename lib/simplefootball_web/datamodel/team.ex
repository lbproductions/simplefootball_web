defmodule SimplefootballWeb.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field(:name, :string)
    field(:abbreviation, :string)
    field(:alternative_names, {:array, :string})
    field(:tm_identifier, :string)
  end

  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :abbreviation, :alternative_names, :tm_identifier])
  end
end
