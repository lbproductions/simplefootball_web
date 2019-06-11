defmodule SimplefootballWebWeb.TeamRepoTest do
  use SimplefootballWebWeb.ConnCase, async: true

  require Logger

  alias SimplefootballWeb.{TeamRepo, Repo, Team}

  test "try to find a not existing team" do
    Repo.delete_all(Team)

    assert TeamRepo.team_by_tm_identifier("1234567") == nil
  end

  test "try to find an existing team by tm identifier" do
    Repo.delete_all(Team)

    tm_identifier = "1234567"
    name = "Borussia Dortmund"

    {:ok, _} =
      Repo.insert(%Team{
        tm_identifier: tm_identifier,
        name: name
      })

    result = TeamRepo.team_by_tm_identifier(tm_identifier)
    assert result.tm_identifier == tm_identifier
    assert result.name == name

    Repo.delete_all(Team)
  end

  test "create a new team by tm identifier" do
    Repo.delete_all(Team)
    tm_identifier = "1234567"
    name = "Borussia Dortmund"

    {:ok, result} =
      TeamRepo.update_or_create_team_by_tm_identifier(
        tm_identifier,
        %{
          tm_identifier: tm_identifier,
          name: name
        }
      )

    assert result.tm_identifier == tm_identifier
    assert result.name == name
  end

  test "update existing team by tm identifier" do
    Repo.delete_all(Team)

    tm_identifier = "1234567"
    old_name = "BV Borussia Dortmund"

    {:ok, _} =
      Repo.insert(%Team{
        tm_identifier: tm_identifier,
        name: old_name
      })

    new_name = "Borussia Dortmund"

    {:ok, result} =
      TeamRepo.update_or_create_team_by_tm_identifier(
        tm_identifier,
        %{
          tm_identifier: tm_identifier,
          name: new_name
        }
      )

    assert result.tm_identifier == tm_identifier
    assert result.name == new_name

    Repo.delete_all(Team)
  end
end
