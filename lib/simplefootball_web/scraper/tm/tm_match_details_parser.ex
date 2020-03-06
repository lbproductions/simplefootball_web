defmodule SimplefootballWeb.TMMatchDetailsParser do
  import Meeseeks.XPath
  require Logger
  use Timex
  import Jason

  alias SimplefootballWeb.{StringHelpers, ArrayHelpers, DateHelpers}

  @after_extra_time "n.V."
  @after_penalties "n.E."
  @halftime "HZ"
  @in_extra_time "i.V."
  @in_penalties "i.E."
  @own_goal "Eigentor"

  # Live Details
  def scrape_live_match_details(data, identifier) do
    document = Meeseeks.parse(data)
    result = result(document, identifier)
    is_extra_time = is_extra_time(document)
    is_penalties = is_penalties(document)
    date = live_date(document)
    home_team = team_from_element(live_home_element(document))
    away_team = team_from_element(live_away_element(document))
    stadium = stadium_from_element(document, true)
    referee = referee_from_element(document, true)

    json_events = live_events_json(document)
    lineups = lineups_from_json(json_events)
    events = events_from_json(json_events)
    minute = minute_from_json(json_events)

    %{
      result: result,
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team,
      stadium: stadium,
      referee: referee,
      lineups: lineups,
      events: events,
      minute: minute
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

  def live_events_json(document) do
    json_string =
      Meeseeks.one(document, xpath("//tm-ticker"))
      |> Meeseeks.attr("coverage")

    if json_string != nil do
      Jason.decode!(json_string)
    else
      nil
    end
  end

  def lineups_from_json(json) when is_nil(json), do: nil

  def lineups_from_json(json) do
    home_start = lineup_from_json(json["lineups"]["home"]["start"])
    home_bench = lineup_from_json(json["lineups"]["home"]["subs"])
    away_start = lineup_from_json(json["lineups"]["away"]["start"])
    away_bench = lineup_from_json(json["lineups"]["away"]["subs"])

    %{
      home: %{
        start: home_start,
        bench: home_bench
      },
      away: %{
        start: away_start,
        bench: away_bench
      }
    }
  end

  def lineup_from_json(json) when is_nil(json), do: nil

  def lineup_from_json(json) do
    json
    |> Enum.map(fn element -> player_from_json(element) end)
  end

  def player_from_json(json) do
    %{
      tm_identifier: json["id"],
      name: json["name"],
      shirt_number: json["shirt"],
      position: json["position"]
    }
  end

  def events_from_json(json) when is_nil(json), do: nil

  def events_from_json(json) do
    goals = goals_from_json(json)
    cards = cards_from_json(json)
    subs = subs_from_json(json)

    %{
      goals: goals,
      cards: cards,
      subs: subs
    }
  end

  def goals_from_json(json) do
    home_goals =
      (json["goals"]["home"] ||
         [])
      |> Enum.map(fn element -> goal_from_json(element, true) end)

    away_goals =
      (json["goals"]["away"] ||
         [])
      |> Enum.map(fn element -> goal_from_json(element, false) end)

    home_goals ++ away_goals
  end

  def goal_from_json(json, is_home) do
    %{
      minute: json["minute"],
      scorer: %{
        tm_identifier: json["scorer"],
        name: json["scorername"]
      },
      assist: %{
        tm_identifier: json["assist"],
        name: json["assistname"]
      },
      is_home: is_home,
      type: json["type"]
    }
  end

  def cards_from_json(json) do
    home_cards =
      (json["cards"]["home"] ||
         [])
      |> Enum.map(fn element -> card_from_json(element, true) end)

    away_cards =
      (json["cards"]["away"] ||
         [])
      |> Enum.map(fn element -> card_from_json(element, false) end)

    home_cards ++ away_cards
  end

  def card_from_json(json, is_home) do
    %{
      minute: json["minute"],
      is_home: is_home,
      player: %{
        tm_identifier: json["player"],
        name: json["name"]
      },
      type: json["type"]
    }
  end

  def subs_from_json(json) do
    home_cards =
      (json["subs"]["home"] ||
         [])
      |> Enum.map(fn element -> sub_from_json(element, true) end)

    away_cards =
      (json["subs"]["away"] ||
         [])
      |> Enum.map(fn element -> sub_from_json(element, false) end)

    home_cards ++ away_cards
  end

  def sub_from_json(json, is_home) do
    %{
      minute: json["minute"],
      is_home: is_home,
      player_on: %{
        tm_identifier: json["on"],
        name: json["onname"]
      },
      player_off: %{
        tm_identifier: json["off"],
        name: json["offname"]
      }
    }
  end

  def minute_from_json(json) do
    if json == nil do
      nil
    else
      json["minute"]
    end
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
    stadium = stadium_from_element(document, false)
    referee = referee_from_element(document, false)

    events = report_events(document)

    %{
      result: result,
      is_extra_time: is_extra_time,
      is_penalties: is_penalties,
      date: date,
      home_team: home_team,
      away_team: away_team,
      stadium: stadium,
      referee: referee,
      events: events
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

    DateHelpers.date_from_strings(date_string, time_string)
  end

  def report_home_element(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-team sb-heim hide-for-small']/a"))
  end

  def report_away_element(document) do
    Meeseeks.one(document, xpath("//div[@class='sb-team sb-gast hide-for-small']/a"))
  end

  def report_events(document) do
    %{
      goals: report_goals(document)
    }
  end

  def report_goals(document) do
    Meeseeks.all(document, xpath("//div[@id='sb-tore']/ul/li"))
    |> Enum.map(fn element -> report_goal(element) end)
    |> Enum.with_index()
    |> Enum.map(fn {element, index} -> report_assign_minute_to_goal(document, element, index) end)
  end

  def report_assign_minute_to_goal(document, goal, index) do
    minutes = report_minutes(document, "sb-tor")
    minute = Enum.at(minutes, index)
    Map.merge(goal, %{minute: minute})
  end

  def report_goal(element) do
    player_tm_identifier =
      Meeseeks.one(element, xpath(".//div[@class='sb-aktion-aktion']/a"))
      |> Meeseeks.attr("id")

    team_tm_identifier =
      Meeseeks.one(element, xpath(".//div[@class='sb-aktion-wappen']/a"))
      |> Meeseeks.attr("id")

    is_own_goal =
      Meeseeks.one(element, xpath(".//div[@class='sb-aktion-aktion']"))
      |> Meeseeks.text()
      |> String.contains?([@own_goal])

    %{
      player: %{
        tm_identifier: player_tm_identifier
      },
      team: %{
        tm_identifier: team_tm_identifier
      },
      is_own_goal: is_own_goal
    }
  end

  def report_minutes(document, event_type) do
    (report_minutes(document, event_type, true) ++ report_minutes(document, event_type, false))
    |> Enum.sort()
  end

  def report_minutes(document, event_type, is_home) do
    home_identifier = report_minutes_home_identifier(is_home)
    total_minutes = report_total_minutes(document)

    Meeseeks.all(document, xpath(".//div[@class='#{home_identifier}']/div"))
    |> Enum.filter(fn element ->
      Meeseeks.one(element, xpath(".//span[@class='sb-sprite #{event_type}']")) != nil
    end)
    |> Enum.map(fn element -> report_minute(element, total_minutes) end)
  end

  def report_minute(element, total_minutes) do
    double_value =
      element
      |> Meeseeks.attr("style")
      |> String.split(";", trim: true)
      |> List.first()
      |> String.split(":", trim: true)
      |> List.last()
      |> String.split("%", trim: true)
      |> List.first()
      |> trim_result()
      |> Float.parse()
      |> elem(0)

    (double_value / 100.0 * total_minutes + 1)
    |> Kernel.trunc()
  end

  def report_minutes_home_identifier(is_home) do
    if is_home do
      "sb-leiste-heim"
    else
      "sb-leiste-gast"
    end
  end

  def report_total_minutes(document) do
    is_extra_time = is_extra_time(document)

    if is_extra_time do
      120
    else
      90
    end
  end

  def report_goal_event_type(goal) do
    if goal.is_own_goal == true do
      "sb-eigentor"
    else
      "sb-tor"
    end
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
    %{
      tm_identifier: Meeseeks.attr(element, "id"),
      name:
        Meeseeks.one(element, xpath(".//img"))
        |> Meeseeks.attr("alt")
    }
  end

  def stadium_from_element(element, is_live) do
    identifier = stadium_identifier(is_live)

    name =
      Meeseeks.one(element, xpath("//p[@class='#{identifier}']/span/a"))
      |> Meeseeks.text()

    %{
      name: name,
      number_of_spectators: stadium_number_of_spectators(element, identifier)
    }
  end

  def stadium_identifier(is_live) do
    if is_live do
      "sbk-zusatzinfos"
    else
      "sb-zusatzinfos"
    end
  end

  def stadium_number_of_spectators(element, identifier) do
    number_of_spectators_text =
      Meeseeks.one(element, xpath("//p[@class='#{identifier}']/span/strong"))
      |> Meeseeks.text()

    if number_of_spectators_text != nil do
      number_of_spectators_text
      |> StringHelpers.split(" ", trim: true)
      |> List.first()
      |> String.replace(".", "")
      |> Integer.parse()
      |> elem(0)
    else
      nil
    end
  end

  def referee_from_element(element, is_live) do
    identifier = stadium_identifier(is_live)

    name =
      Meeseeks.one(element, xpath("//p[@class='#{identifier}']/a"))
      |> Meeseeks.text()

    href =
      Meeseeks.one(element, xpath("//p[@class='#{identifier}']/a"))
      |> Meeseeks.attr("href")

    %{
      name: name,
      href: href
    }
  end
end
