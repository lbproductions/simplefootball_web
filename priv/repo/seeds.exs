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

alias SimplefootballWeb.{Repo, Competition, Season, Matchday, Match, Team}

defmodule DataCreation do
  def create(competition) do
    Repo.insert!(competition)
  end
end

{:ok, bundesliga} =
  DataCreation.create(%Competition{
    name: "1. Bundesliga",
    competition_type: "bundesliga",
    icon_url:
      "https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Bundesliga_logo_%282017%29.svg/290px-Bundesliga_logo_%282017%29.svg.png"
  })

{:ok, bundesliga2018} =
  DataCreation.create(%Season{
    year: 2018,
    competition_id: bundesliga.id
  })

{:ok, bundesliga2018matchday24} =
  DataCreation.create(%Matchday{
    number: 24,
    description: "24. Spieltag",
    season_id: bundesliga2018.id,
    is_current_matchday: true
  })

{:ok, bundesliga2018matchday24match1homeTeam} =
  DataCreation.create(%Team{
    name: "Borussia Dortmund",
    abbreviation: "BVB"
  })

{:ok, bundesliga2018matchday24match1awayTeam} =
  DataCreation.create(%Team{
    name: "Bayer Leverkusen",
    abbreviation: "B04"
  })

{:ok, bundesliga2018matchday24match1} =
  DataCreation.create(%Match{
    date: DateTime.truncate(DateTime.utc_now(), :second),
    result: "2:1",
    matchday_id: bundesliga2018matchday24.id,
    after_penalties: false,
    extra_time: false,
    home_team_id: bundesliga2018matchday24match1homeTeam.id,
    away_team_id: bundesliga2018matchday24match1awayTeam.id
  })
