defmodule SimplefootballWeb.Updater do
  require Logger
  use Task
  alias SimplefootballWeb.{Scraper, CompetitionRepo, Competition}

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do
    poll_current_matchdays()
  end

  defp poll_current_matchdays do
    receive do
    after
      60_000 ->
        get_current_matchdays()
        poll_current_matchdays()
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
end
