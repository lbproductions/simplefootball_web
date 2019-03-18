defmodule SimplefootballWeb.TMHttpService do
  @base_url "www.transfermarkt.de"

  def matchday(competition_identifier, season_year, number) do
    HTTPoison.get(
      "https://#{@base_url}/#{competition_identifier}?saison_id=#{season_year}&spieltag=#{number}"
    ).body
  end

  def tm_competition_identifier(competition) do
    case competition.competition_type do
      :bundesliga -> "1-bundesliga/spieltag/wettbewerb/L1/plus/0"
      _ -> nil
    end
  end
end
