defmodule SimplefootballWeb.TMUpdater do
  require Logger
  use Task

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do
    receive do
    after
      5_000 ->
        get_data()
        poll()
    end
  end

  defp get_data() do
    Logger.debug(fn ->
      "get_data"
    end)
  end
end
