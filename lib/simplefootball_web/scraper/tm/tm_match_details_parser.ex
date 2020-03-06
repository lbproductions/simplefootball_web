defmodule SimplefootballWeb.TMMatchDetailsParser do
  import Meeseeks.XPath
  require Logger
  use Timex

  alias SimplefootballWeb.{StringHelpers, ArrayHelpers, DateHelpers}

  @after_extra_time "n.V."
  @after_penalties "n.E."
  @halftime "HZ"
  @in_extra_time "i.V."
  @in_penalties "i.E."

  # Live Details
  def scrape_live_match_details(data, identifier) do
    document = Meeseeks.parse(data)
    result = result(document, identifier)
    is_extra_time = is_extra_time(document)
    is_penalties = is_penalties(document)
    date = live_date(document)
    home_team = team_from_element(live_home_element(document))
    away_team = team_from_element(live_away_element(document))

    Logger.debug(fn ->
      "home_team: #{inspect(home_team)}"
    end)

    Logger.debug(fn ->
      "away_team: #{inspect(away_team)}"
    end)

    %{
      result: result,
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team
    }
  end

  def live_date(document) do
    time_string =
      Meeseeks.one(document, xpath("//div[@class='sbk-datum']"))
      |> DateHelpers.time_string()

    date_string =
      DateHelpers.date_string(Meeseeks.one(document, xpath("//div[@class='sbk-datum']")))

    DateHelpers.date_from_strings(date_string, time_string)
  end

  def live_home_element(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-team sb-heim hide-for-small']/a"))
  end

  def live_away_element(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-team sb-gast hide-for-small']/a"))
  end

  # Report Details
  def scrape_report_match_details(data, identifier) do
    document = Meeseeks.parse(data)
    result = result(document, identifier)
    is_extra_time = is_extra_time(document)
    is_penalties = is_penalties(document)
    date = report_date(document)
    home_team = team_from_element(report_home_element(document))
    away_team = team_from_element(report_away_element(document))

    %{
      result: result,
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team
    }
  end

  def report_date(document) do
    time_string =
      Meeseeks.one(document, xpath("//p[@class='sb-datum hide-for-small']"))
      |> DateHelpers.time_string()

    date_string =
      DateHelpers.date_string(
        Meeseeks.one(document, xpath("//p[@class='sb-datum hide-for-small']"))
      )

    date_element =
      Meeseeks.one(document, xpath("//p[@class='sb-datum hide-for-small']"))
      |> Meeseeks.text()

    DateHelpers.date_from_strings(date_string, time_string)
  end

  def report_home_element(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-team sb-heim hide-for-small']"))
  end

  def report_away_element(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-team sb-gast hide-for-small']"))
  end

  # Common

  def result(document, identifier) do
    result = result_text(document)

    if result == "-:-" do
      Meeseeks.one(document, xpath("//a[@href='/ticker/begegnung/live/#{identifier}']")) ||
        Meeseeks.one(
          document,
          xpath("//a[@href='/spielbericht/index/spielbericht/#{identifier}']")
        )
        |> Meeseeks.text()
        |> trim_result()
    else
      result
    end
  end

  def result_text(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-endstand']"))
    |> Meeseeks.text()
    |> trim_result()
  end

  def trim_result(result) do
    result
    |> String.split(@after_extra_time, trim: true)
    |> List.first()
    |> String.split(@after_penalties, trim: true)
    |> List.first()
    |> String.split(@halftime, trim: true)
    |> List.first()
    |> String.split(@in_extra_time, trim: true)
    |> List.first()
    |> String.split(@in_penalties, trim: true)
    |> List.first()
    |> String.split("(", trim: true)
    |> List.first()
    |> StringHelpers.trim()
  end

  def is_extra_time(document) do
    # when the result parsing fails with the first try, we are not able to detect some extra time
    result = result_text(document)

    if result == "-:-" do
      nil
    else
      Meeseeks.one(document, xpath("//div[@class='sb-endstand']"))
      |> Meeseeks.text()
      |> String.contains?([@after_extra_time, @in_extra_time])
    end
  end

  def is_penalties(document) do
    result = result_text(document)

    # when the result parsing fails with the first try, we are not able to detect some penalties
    if result == "-:-" do
      nil
    else
      Meeseeks.one(document, xpath("//div[@class='sb-endstand']"))
      |> Meeseeks.text()
      |> String.contains?([@after_penalties, @in_penalties])
    end
  end

  def team_from_element(element) do
    Logger.debug(fn ->
      "element: #{inspect(element)}"
    end)

    %{
      tm_identifier: Meeseeks.attr(element, "id"),
      name:
        Meeseeks.one(element, xpath(".//img"))
        |> Meeseeks.attr("alt")
    }
  end
end
