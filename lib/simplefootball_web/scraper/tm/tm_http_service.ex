defmodule SimplefootballWeb.TMHttpService do
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
end
