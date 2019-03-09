defmodule SimplefootballWebWeb.ScraperTest do
  use SimplefootballWebWeb.ConnCase, async: true

  import HTTPoison
  import Meeseeks.XPath
  require Logger
  use Timex

  alias SimplefootballWeb.{TMMatchdayScraper, Season, Repo}

  test "scrape" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/bundesliga_2018_18.html")

    {:ok, season} =
      Repo.insert(%Season{
        year: 2018
      })

    # html =
    #   HTTPoison.get!(
    #     "https://www.transfermarkt.de/1-bundesliga/spieltag/wettbewerb/L1/plus/0?saison_id=2018&spieltag=24"
    #   ).body

    result = TMMatchdayScraper.scrape_matchday(result, season.id, 18)

    Logger.debug(fn ->
      "result: #{inspect(result)}"
    end)
  end
end
