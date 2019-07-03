defmodule SimplefootballWeb.TMHttpService do
  require Logger

  @base_url "www.transfermarkt.de"

  def base_url() do
    @base_url
  end

  def matchday(competition_identifier, season_year, number) do
    result =
      HTTPoison.get(
        "https://#{@base_url}/#{competition_identifier}?saison_id=#{season_year}&spieltag=#{
          number
        }"
      )

    case result do
      {:ok, data} -> data.body
      _ -> nil
    end
  end

  def tm_competition_identifier(competition) do
    case competition.competition_type do
      :bundesliga -> "1-bundesliga/spieltag/wettbewerb/L1/plus/0"
      _ -> nil
    end
  end

  def tm_current_matchday(competition) do
    url = tm_competition_current_matchday_url(competition)

    Logger.debug(fn ->
      "tm_current_matchday: #{inspect(url)}"
    end)

    result = HTTPoison.get(url)

    case result do
      {:ok, data} -> data.body
      _ -> nil
    end
  end

  def tm_competition_current_matchday_url(competition) do
    "https://#{@base_url}/#{tm_competition_current_matchday_url_path(competition)}"
  end

  def tm_competition_current_matchday_url_path(competition) do
    case competition.competition_type do
      :bundesliga -> "1-bundesliga/startseite/wettbewerb/L1"
      :bundesliga2 -> "2-bundesliga/startseite/wettbewerb/L2"
      :regionalligaWest -> "regionalliga-west/startseite/wettbewerb/RLW3"
      :dfbPokal -> "dfb-pokal/startseite/pokalwettbewerb/DFB"
      :championsLeague -> "champions-league/startseite/pokalwettbewerb/CL"
      :europaLeague -> "europa-league/startseite/pokalwettbewerb/EL"
      :premierLeague -> "premier-league/startseite/wettbewerb/GB1"
      :laLiga -> "primera-division/startseite/wettbewerb/ES1"
      :serieA -> "serie-a/startseite/wettbewerb/IT1"
      :ligue1 -> "ligue-1/startseite/wettbewerb/FR1"
      _ -> nil
    end
  end
end
