defmodule SimplefootballWebWeb.ScraperTest do
  use SimplefootballWebWeb.ConnCase, async: true

  import HTTPoison
  import Meeseeks.XPath
  require Logger

  test "scrape" do
    {:ok, result} =
      File.read("./test/simplefootball_web_web/resources/tm/bundesliga_2018_18.html")

    # html =
    #   HTTPoison.get!(
    #     "https://www.transfermarkt.de/1-bundesliga/spieltag/wettbewerb/L1/plus/0?saison_id=2018&spieltag=18"
    #   ).body

    document = Meeseeks.parse(result)
    gameTables = Meeseeks.all(document, xpath("//table[@style='border-top: 0 !important;']"))
    result = Enum.map(gameTables, fn table -> match(table) end)
  end

  def match(table) do
    names =
      Meeseeks.all(table, xpath(".//a[@class='vereinprofil_tooltip']"))
      |> Enum.map(fn name -> Meeseeks.text(name) end)
      |> Enum.filter(fn name -> name != "" end)
      |> split()

    Logger.debug(fn ->
      "names: #{inspect(names)}"
    end)
  end

  def split(list) do
    len = round(length(list) / 2)
    Enum.split(list, len)
  end
end
