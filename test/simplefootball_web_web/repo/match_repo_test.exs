defmodule SimplefootballWebWeb.MatchRepoTest do
  use SimplefootballWebWeb.ConnCase, async: true

  require Logger

  alias SimplefootballWeb.{MatchRepo, Repo, Match}

  test "try to find a not existing match" do
    Repo.delete_all(Match)

    assert MatchRepo.match_by_tm_identifier("1234567") == nil
  end

  test "try to find an existing match" do
    Repo.delete_all(Match)

    tm_identifier = "1234567"
    match_result = "2:2"

    {:ok, _} =
      Repo.insert(%Match{
        tm_identifier: tm_identifier,
        result: match_result
      })

    result = MatchRepo.match_by_tm_identifier(tm_identifier)
    assert result.tm_identifier == tm_identifier
    assert result.result == match_result

    Repo.delete_all(Match)
  end

  test "create a new match by tm identifier" do
    Repo.delete_all(Match)
    tm_identifier = "1234567"
    match_result = "2:2"

    {:ok, result} =
      MatchRepo.update_or_create_match_by_tm_identifier(
        tm_identifier,
        %{
          tm_identifier: tm_identifier,
          result: match_result
        }
      )

    assert result.tm_identifier == tm_identifier
    assert result.result == match_result
  end

  test "update existing match by tm identifier" do
    Repo.delete_all(Match)

    tm_identifier = "1234567"
    old_result = "1:2"

    {:ok, _} =
      Repo.insert(%Match{
        tm_identifier: tm_identifier,
        result: old_result
      })

    new_result = "2:2"

    {:ok, result} =
      MatchRepo.update_or_create_match_by_tm_identifier(
        tm_identifier,
        %{
          tm_identifier: tm_identifier,
          result: new_result
        }
      )

    assert result.tm_identifier == tm_identifier
    assert result.result == new_result

    Repo.delete_all(Match)
  end
end
