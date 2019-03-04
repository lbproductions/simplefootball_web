defmodule SimplefootballWeb.Team do
  use Ecto.Schema

  schema "teams" do
    field(:name, :string)
    field(:abbreviation, :string)
    field(:alternative_names, {:array, :string})
    field(:tm_identifier, :string)
  end
end
