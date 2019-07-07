defmodule SimplefootballWeb.Updater do
  require Logger
  use Task
  alias SimplefootballWeb.{Scraper, CompetitionRepo, Competition, SeasonRepo}

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do
    # poll_current_matchdays()
    # poll_matchdays()
  end

  defp poll_current_matchdays do
    receive do
    after
      60_000 ->
        get_current_matchdays()
        poll_current_matchdays()
    end
  end

  defp poll_matchdays do
    receive do
    after
      5_000 ->
        get_matchdays()
    end
  end

  defp get_current_matchdays() do
    Logger.debug(fn ->
      "get_current_matchdays"
    end)

    config = Application.get_env(:simplefootball_web, __MODULE__, [])

    scraper = config[:matchday_scraper]

    Competition.competition_types()
    |> Enum.map(fn competition_type ->
      competition = CompetitionRepo.competition_by_type(competition_type)

      get_current_matchday(
        competition,
        scraper
      )
    end)
  end

  defp get_current_matchday(competition, scraper) do
    Logger.debug(fn ->
      "get_current_matchday: #{inspect(competition.name)}"
    end)

    result = Scraper.current_matchday(scraper, competition)

    Logger.debug(fn ->
      "Current #{inspect(competition.name)} matchday: #{inspect(result.matchday.description)}"
    end)

    result
  end

  defp get_matchdays() do
    Logger.debug(fn ->
      "get_current_matchdays"
    end)

    config = Application.get_env(:simplefootball_web, __MODULE__, [])

    scraper = config[:matchday_scraper]

    Competition.competition_types()
    |> Enum.map(fn competition_type ->
      competition = CompetitionRepo.competition_by_type(competition_type)

      get_matchdays(
        competition,
        scraper
      )
    end)
  end

  defp get_matchdays(competition, scraper) do
    year = 2018
    {:ok, season} = SeasonRepo.find_or_create_season_by(year: year, competition: competition)
    matchdays = 1..number_of_matchdays(year, competition)

    Enum.map(matchdays, fn matchday ->
      get_matchday(competition, season, matchday, scraper)
    end)
  end

  defp get_matchday(competition, season, number, scraper) do
    Scraper.matchday(scraper, competition, season, number)
  end

  defp number_of_matchdays(_season, competition) do
    case competition.competition_type do
      :bundesliga -> 34
      :bundesliga2 -> 34
      :regionalligaWest -> 34
      :dfbPokal -> 6
      :championsLeague -> 13
      :europaLeague -> 15
      :premierLeague -> 38
      :laLiga -> 38
      :serieA -> 38
      :ligue1 -> 38
    end
  end
end
