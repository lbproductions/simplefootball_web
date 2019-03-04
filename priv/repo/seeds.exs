# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SimplefootballWeb.Repo.insert!(%SimplefootballWeb.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SimplefootballWeb.{Repo, Competition}

defmodule DataCreation do
  def createCompetition(competition) do
    Repo.insert!(competition)
  end
end

DataCreation.createCompetition(%Competition{
  name: "1. Bundesliga",
  competition_type: "bundesliga",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Bundesliga_logo_%282017%29.svg/290px-Bundesliga_logo_%282017%29.svg.png"
})
