defmodule SimplefootballWebWeb.TMHttpServiceTest do
  use SimplefootballWebWeb.ConnCase, async: true

  require Logger
  import Mock
  import HTTPoison
  alias SimplefootballWeb.{TMHttpService, Competition, CompetitionType}

  test "get a competion identifier for a existing competition type" do
    competition = %Competition{
      competition_type: :bundesliga
    }

    assert TMHttpService.tm_competition_identifier(competition) ==
             "1-bundesliga/spieltag/wettbewerb/L1/plus/0"
  end

  test "get nil for a not handled competition" do
    competition = %Competition{
      competition_type: :bundesliga3
    }

    assert TMHttpService.tm_competition_identifier(competition) == nil
  end

  test "get the matchday data for a competition identifier, a year and a matchday number" do
    result_data = %{
      body: "<html></html>"
    }

    result = {:ok, result_data}

    competition_identifier = "1-bundesliga/spieltag/wettbewerb/L1/plus/0"
    season_year = 2018
    number = 1
    base_url = TMHttpService.base_url()

    expected_url =
      "https://#{base_url}/#{competition_identifier}?saison_id=#{season_year}&spieltag=#{number}"

    with_mock HTTPoison,
      get: fn url ->
        case url do
          ^expected_url -> result
          _ -> ""
        end
      end do
      assert result_data.body ==
               TMHttpService.matchday(competition_identifier, season_year, number)
    end
  end
end
