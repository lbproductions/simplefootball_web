defmodule SimplefootballWebWeb.ScraperTest do
  use SimplefootballWebWeb.ConnCase, async: true

  import HTTPoison
  import Meeseeks.XPath
  require Logger

  test "scrape" do
    html =
      HTTPoison.get!(
        "https://www.transfermarkt.de/1-bundesliga/spieltag/wettbewerb/L1/plus/0?saison_id=2018&spieltag=18"
      ).body

    document = Meeseeks.parse(html)
    result = Meeseeks.all(document, xpath("//table[@style='border-top: 0 !important;']"))

    Logger.debug(fn ->
      "result: #{inspect(result)}"
    end)
  end
end
