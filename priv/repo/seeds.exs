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

DataCreation.create(%Competition{
  name: "1. Bundesliga",
  competition_type: "bundesliga",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/d/df/Bundesliga_logo_%282017%29.svg/290px-Bundesliga_logo_%282017%29.svg.png"
})

DataCreation.create(%Competition{
  name: "2. Bundesliga",
  competition_type: "bundesliga2",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/7/7b/2._Bundesliga_logo.svg/380px-2._Bundesliga_logo.svg.png"
})

DataCreation.create(%Competition{
  name: "Regionalliga West",
  competition_type: "regionalligaWest",
  icon_url: "https://www.rot-blau.com/berichte/1213/logo_regionalliga-west_2012-2013.jpg"
})

DataCreation.create(%Competition{
  name: "DFB-Pokal",
  competition_type: "dfbPokal",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/9/9f/DFB-Pokal_logo_2016.svg/440px-DFB-Pokal_logo_2016.svg.png"
})

DataCreation.create(%Competition{
  name: "Champions League",
  competition_type: "championsLeague",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/b/bf/UEFA_Champions_League_logo_2.svg/350px-UEFA_Champions_League_logo_2.svg.png"
})

DataCreation.create(%Competition{
  name: "Europa League",
  competition_type: "europaLeague",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/0/03/Europa_League.svg/270px-Europa_League.svg.png"
})

DataCreation.create(%Competition{
  name: "Premier League",
  competition_type: "premierLeague",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Premier_League_Logo.svg/500px-Premier_League_Logo.svg.png"
})

DataCreation.create(%Competition{
  name: "La Liga",
  competition_type: "laLiga",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/LaLiga.svg/500px-LaLiga.svg.png"
})

DataCreation.create(%Competition{
  name: "Serie A",
  competition_type: "serieA",
  icon_url: "https://upload.wikimedia.org/wikipedia/en/0/02/Serie_A_logo_%282018%29.png"
})

DataCreation.create(%Competition{
  name: "Ligue 1",
  competition_type: "ligue1",
  icon_url:
    "https://upload.wikimedia.org/wikipedia/en/thumb/d/dd/Ligue_1_Logo.svg/500px-Ligue_1_Logo.svg.png"
})
