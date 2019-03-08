defmodule SimplefootballWebWeb.ScraperTest do
  use SimplefootballWebWeb.ConnCase, async: true

  import HTTPoison
  import Meeseeks.XPath
  require Logger
  use Timex

  alias SimplefootballWeb.{Match, Team}

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
    elements = Meeseeks.all(table, xpath(".//a[@class='vereinprofil_tooltip']"))

    names =
      elements
      |> Enum.map(fn name -> Meeseeks.text(name) end)
      |> Enum.filter(fn name -> name != "" end)
      |> split()

    Logger.debug(fn ->
      "names: #{inspect(names)}"
    end)

    teamIdentifiers =
      elements
      |> Enum.map(fn element -> Meeseeks.attr(element, "id") end)
      |> Enum.filter(fn element -> element != "" end)
      |> uniq()

    resultElement =
      Meeseeks.one(table, xpath(".//a[@title='Vorbericht']")) ||
        Meeseeks.one(table, xpath(".//a[@class='ergebnis-link live-ergebnis']")) ||
        Meeseeks.one(table, xpath(".//a[@class='ergebnis-link']"))

    result = Meeseeks.text(resultElement)

    identifier =
      Meeseeks.attr(resultElement, "href")
      |> String.split("/", trim: true)
      |> List.last()

    date = date(table, 2) || date(table, 3)

    Logger.debug(fn ->
      "teamIdentifiers: #{inspect(teamIdentifiers)}"
    end)

    Logger.debug(fn ->
      "result: #{inspect(result)}, identifier: #{identifier}, date: #{date}"
    end)

    # find or create team and match by tm identifier

    %Match{
      date: date,
      result: result,
      tm_identifier: identifier,
      home_team_id: bundesliga2018matchday24match1homeTeam.id,
      away_team_id: bundesliga2018matchday24match1awayTeam.id
    }
  end

  # Scraper Helpers

  def date(element, index) do
    dateString =
      Meeseeks.one(element, xpath(".//tr[#{index}]/td/a"))
      |> Meeseeks.text()
      |> nilIfEmpty()

    timeString = time(element, index)

    Logger.debug(fn ->
      "dateString: #{inspect(dateString)}, timeString: #{inspect(timeString)}"
    end)

    if timeString == nil || dateString == nil do
      nil
    else
      {:ok, date} = Timex.parse(dateString, "%d.%m.%Y", :strftime)

      {:ok, time} = Timex.parse(timeString, "%H:%M", :strftime)

      Timex.shift(date, hours: time.hour, minutes: time.minute)
      |> Timex.to_datetime("Europe/Berlin")
      |> Timezone.convert(Timezone.get("UTC", date))
    end
  end

  def time(element, index) do
    Meeseeks.one(element, xpath(".//tr[#{index}]/td"))
    |> Meeseeks.text()
    |> String.trim()
    |> String.replace(" Uhr", "")
    |> String.split(" ", trim: true)
    |> List.last()
    |> nilIfEmpty()
  end

  # String Helpers

  def nilIfEmpty(string) do
    if string == "" do
      nil
    else
      string
    end
  end

  # Array Helpers

  def split(list) do
    len = round(length(list) / 2)
    Enum.split(list, len)
  end

  def uniq(list) do
    uniq(list, HashSet.new())
  end

  defp uniq([x | rest], found) do
    if HashSet.member?(found, x) do
      uniq(rest, found)
    else
      [x | uniq(rest, HashSet.put(found, x))]
    end
  end

  defp uniq([], _) do
    []
  end
end
