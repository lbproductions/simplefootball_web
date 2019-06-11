defmodule SimplefootballWeb.TMParser do
  import Meeseeks.XPath
  require Logger
  use Timex

  alias SimplefootballWeb.{StringHelpers, ArrayHelpers}

  def scrape_matchday(data) do
    document = Meeseeks.parse(data)

    %{
      matches: scrape_matches(document)
    }
  end

  def scrape_matches(document) do
    gameTables = Meeseeks.all(document, xpath("//table[@style='border-top: 0 !important;']"))

    Enum.map(gameTables, fn table -> match(table) end)
    |> Enum.sort(fn x, y ->
      case DateTime.compare(x.match.date, y.match.date) do
        :lt -> true
        _ -> false
      end
    end)
  end

  def teams(table) do
    elements = Meeseeks.all(table, xpath(".//a[@class='vereinprofil_tooltip']"))

    {home_names, away_names} =
      elements
      |> Enum.map(fn name -> Meeseeks.text(name) end)
      |> Enum.filter(fn name -> name != "" end)
      |> ArrayHelpers.split()

    home_name = List.first(home_names)
    home_abbrevation = List.last(home_names)
    away_name = List.first(away_names)
    away_abbrevation = List.last(away_names)

    teamIdentifiers =
      elements
      |> Enum.map(fn element -> Meeseeks.attr(element, "id") end)
      |> Enum.filter(fn element -> element != "" end)
      |> ArrayHelpers.uniq()

    home_tm_identifier = List.first(teamIdentifiers)
    away_tm_identifier = List.last(teamIdentifiers)

    %{
      home_team: %{
        name: home_name,
        abbreviation: home_abbrevation,
        tm_identifier: home_tm_identifier
      },
      away_team: %{
        name: away_name,
        abbreviation: away_abbrevation,
        tm_identifier: away_tm_identifier
      }
    }
  end

  def match(table) do
    resultElement =
      Meeseeks.one(table, xpath(".//a[@title='Vorbericht']")) ||
        Meeseeks.one(table, xpath(".//a[@class='ergebnis-link live-ergebnis']")) ||
        Meeseeks.one(table, xpath(".//a[@class='ergebnis-link']"))

    result = Meeseeks.text(resultElement)

    match_tm_identifier =
      Meeseeks.attr(resultElement, "href")
      |> String.split("/", trim: true)
      |> List.last()

    date = date(table, 2) || date(table, 3)

    teams = teams(table)

    %{
      home_team: teams.home_team,
      away_team: teams.away_team,
      match: %{
        date: date,
        result: result,
        tm_identifier: match_tm_identifier
      }
    }
  end

  # Scraper Helpers

  def date(element, index) do
    dateString =
      Meeseeks.one(element, xpath(".//tr[#{index}]/td/a"))
      |> Meeseeks.text()
      |> StringHelpers.nilIfEmpty()

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
    |> StringHelpers.nilIfEmpty()
  end
end
