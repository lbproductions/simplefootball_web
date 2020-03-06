defmodule SimplefootballWeb.DateHelpers do
  import Meeseeks.XPath
  use Timex

  alias SimplefootballWeb.{StringHelpers}

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

  def date_string(element) do
    element
    |> Meeseeks.text()
    |> String.trim()
    |> String.split("|", trim: true)
    |> Enum.filter(fn string -> string =~ ", " end)
    |> List.last()
    |> String.trim()
    |> String.split(" ", trim: true)
    |> List.last()
  end

  def time_string(element) do
    element
    |> Meeseeks.text()
    |> String.trim()
    |> String.split("\t", trim: true)
    |> List.last()
    |> String.split("\n", trim: true)
    |> List.last()
    |> String.split("|", trim: true)
    |> Enum.filter(fn string -> string =~ "Uhr" end)
    |> List.last()
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
