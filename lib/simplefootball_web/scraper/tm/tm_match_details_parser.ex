defmodule SimplefootballWeb.TMMatchDetailsParser do
  import Meeseeks.XPath
  require Logger
  use Timex

  alias SimplefootballWeb.{StringHelpers, ArrayHelpers}

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

    %{
      result: result,
      is_extra_time: is_extra_time
    }
  end

  # Report Details
  def scrape_report_match_details(data, identifier) do
    document = Meeseeks.parse(data)
    result = result(document, identifier)
    is_extra_time = is_extra_time(document)

    %{
      result: result,
      is_extra_time: is_extra_time
    }
  end

  # Common

  def result(document, identifier) do
    result =
      Meeseeks.one(document, xpath("//div[@class='sb-endstand']"))
      |> Meeseeks.text()
      |> trim_result()

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
    result =
      Meeseeks.one(document, xpath("//div[@class='sb-endstand']"))
      |> Meeseeks.text()
      |> trim_result()

    # when the result parsing fails with the first try, we are not able to detect some extra time
    if result == "-:-" do
      nil
    else
      Meeseeks.one(document, xpath("//div[@class='sb-endstand']"))
      |> Meeseeks.text()
      |> String.contains?([@after_extra_time, @in_extra_time])
    end
  end
end
