defmodule SimplefootballWeb.TMMatchdayScraper do
  import HTTPoison
  import Meeseeks.XPath
  require Logger
  use Timex

  alias SimplefootballWeb.{
    Match,
    Team,
    MatchRepo,
    TeamRepo,
    StringHelpers,
    ArrayHelpers,
    MatchdayRepo
  }

  def scrape_matchday(data, season_id, number) do
    document = Meeseeks.parse(data)

    {:ok, matchday} =
      MatchdayRepo.update_or_create_matchday_by(
        season_id: season_id,
        number: number,
        changeset: %{
          season_id: season_id,
          number: number
        }
      )

    scrape_matches(document, matchday.id)
    matchday
  end

  def scrape_matches(document, matchday_id) do
    gameTables = Meeseeks.all(document, xpath("//table[@style='border-top: 0 !important;']"))
    Enum.map(gameTables, fn table -> match(table, matchday_id) end)
  end

  def match(table, matchday_id) do
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

    {:ok, home_team} =
      TeamRepo.update_or_create_team_by_tm_identifier(home_tm_identifier, %{
        name: home_name,
        abbreviation: home_abbrevation,
        tm_identifier: home_tm_identifier
      })

    Logger.debug(fn ->
      "home_team: #{inspect(home_team)}"
    end)

    {:ok, away_team} =
      TeamRepo.update_or_create_team_by_tm_identifier(away_tm_identifier, %{
        name: away_name,
        abbreviation: away_abbrevation,
        tm_identifier: away_tm_identifier
      })

    Logger.debug(fn ->
      "away_team: #{inspect(away_team)}"
    end)

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

    # find or create team and match by tm identifier

    {:ok, match} =
      MatchRepo.update_or_create_match_by_tm_identifier(match_tm_identifier, %{
        date: date,
        result: result,
        tm_identifier: match_tm_identifier,
        home_team_id: home_team.id,
        away_team_id: away_team.id,
        matchday_id: matchday_id
      })

    Logger.debug(fn ->
      "match: #{inspect(match)}"
    end)

    match
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
