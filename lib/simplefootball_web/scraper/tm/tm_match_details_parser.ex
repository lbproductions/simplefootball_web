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
  def scrape_live_match_details(data) do
    document = Meeseeks.parse(data)
    result = result(document)

    %{
      result: result
    }
  end

  # Report Details
  def scrape_report_match_details(data) do
    document = Meeseeks.parse(data)
    result = result(document)

    %{
      result: result
    }
  end

  # Common

  def result(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-endstand']"))
    |> Meeseeks.text()
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
end
