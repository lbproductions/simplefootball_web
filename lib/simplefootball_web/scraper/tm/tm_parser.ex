defmodule SimplefootballWeb.TMParser do
  import Meeseeks.XPath
  require Logger
  use Timex

  alias SimplefootballWeb.{StringHelpers, ArrayHelpers}

  @dfbpokalrounds ["1.Runde", "2.Runde", "Achtelfinale", "Viertelfinale", "Halbfinale", "Finale"]

  # Matchday

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

  # Current Matchday
  def scrape_current_matchday(data, competition) do
    document = Meeseeks.parse(data)
    description = current_matchday_description(document, competition)
    number = current_matchday_number_from_description(description, competition)
    matchday_box = matchday_box(document, competition, number)
    matches = current_matchday_matches(matchday_box)
    season = current_matchday_season_from_matches(matches)

    %{
      description: description,
      matches: matches,
      number: number,
      season: season,
      is_current_matchday: true
    }
  end

  def matchday_box(document, competition, matchday_number) do
    matchdayBoxes = Meeseeks.all(document, xpath(".//div[@id='spieltagsbox']"))
    index = matchbox_index(competition)

    # if it's the first matchday of the season we have to take the first instead the second box
    index =
      cond do
        matchday_number == 1 -> index - 1
        true -> index
      end

    Enum.at(matchdayBoxes, index)
  end

  def matchbox_index(competition) do
    case competition.competition_type do
      :bundesliga -> 1
      :bundesliga2 -> 1
      :premierLeague -> 1
      :laLiga -> 1
      :serieA -> 1
      :ligue1 -> 1
      :regionalligaWest -> 1
      _ -> 0
    end
  end

  def current_matchday_description(document, competition) do
    case competition.competition_type do
      :bundesliga -> current_matchday_description_from_footer(document)
      :bundesliga2 -> current_matchday_description_from_footer(document)
      :premierLeague -> current_matchday_description_from_footer(document)
      :laLiga -> current_matchday_description_from_footer(document)
      :serieA -> current_matchday_description_from_footer(document)
      :ligue1 -> current_matchday_description_from_footer(document)
      :regionalligaWest -> current_matchday_description_from_footer(document)
      _ -> current_matchday_description_from_header(document)
    end
  end

  def current_matchday_description_from_header(document) do
    Meeseeks.one(document, xpath(".//div[@class='spieltagsboxHeader']"))
    |> Meeseeks.text()
    |> String.trim()
  end

  def current_matchday_description_from_footer(document) do
    elements = Meeseeks.all(document, xpath(".//div[@class='footer-links fl']/a"))

    matchday_numbers = Enum.map(elements, fn element -> matchday_number_from_element(element) end)
    min_matchday_number = Enum.min(matchday_numbers)

    Logger.debug(fn ->
      "matchday_numbers: #{inspect(matchday_numbers)}"
    end)

    # if it's the first matchday of the season there are no previous matchdays and we
    # take the first matchday
    is_first_or_last = length(matchday_numbers) <= 2

    matchday_number =
      cond do
        min_matchday_number == 1 and is_first_or_last -> min_matchday_number
        is_first_or_last -> List.last(matchday_numbers)
        true -> Enum.at(matchday_numbers, 1)
      end

    "#{matchday_number}. Spieltag"
  end

  @spec matchday_number_from_element(nil | Meeseeks.Result.t()) :: integer
  def matchday_number_from_element(element) do
    element
    |> Meeseeks.text()
    |> String.split("Alle Spiele des ", trim: true)
    |> List.last()
    |> String.split(".Spieltages", trim: true)
    |> List.first()
    |> Integer.parse()
    |> elem(0)
  end

  def current_matchday_number_from_description(description, _competition) do
    if String.contains?(description, ". Spieltag") do
      description
      |> String.split(". Spieltag", trim: true)
      |> List.first()
      |> String.split("Gruppenphase ", trim: true)
      |> List.last()
      |> Integer.parse()
      |> elem(0)
    else
      0
    end
  end

  def current_matchday_season_from_matches(matches) do
    if length(matches) > 0 do
      matches
      |> Enum.filter(fn match -> match != nil end)
      |> List.first()
      |> season_from_match()
    else
      # if we have no matches we take provisionally the current date to get the season
      season_from_match(%{date: Timex.now()})
    end
  end

  def season_from_match(match) do
    match_month = month(match.date)
    match_year = year(match.date)

    if match_month < 7 do
      match_year - 1
    else
      match_year
    end
  end

  def current_matchday_matches(matchday_box) do
    elements = Meeseeks.all(matchday_box, xpath(".//tr[@class='begegnungZeile']"))

    elements
    |> Enum.with_index()
    |> Enum.map(fn {element, index} ->
      day_string = day_string(elements, index)

      current_matchday_match(element, day_string)
    end)
    |> Enum.sort(fn x, y ->
      case DateTime.compare(x.date, y.date) do
        :lt -> true
        _ -> false
      end
    end)
  end

  def day_string(elements, index) do
    Enum.slice(elements, 0..index)
    |> Enum.map(fn element -> day_string(element) end)
    |> Enum.filter(&(!is_nil(&1)))
    |> List.last()
  end

  def day_string(element) do
    element_text =
      Meeseeks.one(element, xpath(".//span[@class='spielzeitpunkt']/a"))
      |> Meeseeks.text()

    if element_text != nil do
      element_text |> String.trim()
    else
      nil
    end
  end

  def current_matchday_match(element, date_string) do
    time_text =
      (Meeseeks.one(element, xpath(".//span[@class='matchresult']")) ||
         Meeseeks.one(element, xpath(".//span[@class='matchresult liveaufstellung']")))
      |> Meeseeks.text()
      |> StringHelpers.nilIfEmpty()

    date = date_from_strings(date_string, time_text)
    match_tm_identifier = Meeseeks.attr(element, "data-id")

    team_elements = Meeseeks.all(element, xpath(".//span[contains(@class, 'vereinsname')]/a"))

    team_names =
      team_elements
      |> Enum.map(fn name -> Meeseeks.text(name) end)
      |> Enum.filter(fn name -> name != nil && name != "" end)

    teamIdentifiers =
      team_elements
      |> Enum.map(fn element -> Meeseeks.attr(element, "id") end)
      |> Enum.filter(fn element -> element != "" end)
      |> ArrayHelpers.uniq()

    is_started = time_text == nil

    live_result =
      Meeseeks.one(element, xpath(".//span[@class='matchresult liveresult']"))
      |> Meeseeks.text()
      |> StringHelpers.nilIfEmpty()

    is_running = live_result != nil

    result_complete =
      if is_started do
        live_result ||
          (Meeseeks.one(element, xpath(".//span[@class='matchresult finished']")) ||
             Meeseeks.one(element, xpath(".//span[@class='matchresult finished noSheet']")))
          |> Meeseeks.text()
          |> StringHelpers.nilIfEmpty()
      else
        "-:-"
      end

    result =
      result_complete
      |> String.split("n.V.", trim: true)
      |> List.first()
      |> String.split("n.E.", trim: true)
      |> List.first()

    is_extra_time = result_complete |> String.contains?("n.V.")
    is_penalty = result_complete |> String.contains?("n.E.")

    group =
      Meeseeks.all(element, xpath("preceding-sibling::tr[@class='rundenzeile']"))
      |> Enum.map(fn element -> Meeseeks.one(element, xpath("./a")) |> Meeseeks.text() end)
      |> List.last()

    %{
      date: date,
      tm_identifier: match_tm_identifier,
      is_started: is_started,
      is_running: is_running,
      result: result,
      is_extra_time: is_extra_time,
      is_penalty: is_penalty,
      home_team: %{
        name: Enum.at(team_names, 0),
        tm_identifier: Enum.at(teamIdentifiers, 0)
      },
      away_team: %{
        name: Enum.at(team_names, 1),
        tm_identifier: Enum.at(teamIdentifiers, 1)
      },
      group: group
    }
  end

  # Scraper Helpers

  def date(element, index) do
    dateString =
      Meeseeks.one(element, xpath(".//tr[#{index}]/td/a"))
      |> Meeseeks.text()
      |> StringHelpers.nilIfEmpty()

    timeString = time(element, index)
    date_from_strings(dateString, timeString)
  end

  def date_from_strings(date_string, time_string) do
    if date_string == nil do
      nil
    else
      {:ok, date} = Timex.parse(date_string, "%d.%m.%Y", :strftime)

      {:ok, time} = Timex.parse(time_string || "00:00", "%H:%M", :strftime)

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

  def month(date) do
    Timex.format!(date, "%m", :strftime)
    |> Integer.parse()
    |> elem(0)
  end

  def year(date) do
    Timex.format!(date, "%Y", :strftime)
    |> Integer.parse()
    |> elem(0)
  end
end
