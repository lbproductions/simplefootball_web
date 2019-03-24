defmodule SimplefootballWebWeb.TMMatchdayScraperTest do
  use SimplefootballWebWeb.ConnCase, async: false

  require Logger
  import Mock
  alias SimplefootballWeb.{TMMatchdayScraper, TMHttpService, Competition, Season}

  test "get a matchday successfully" do
    competition = %Competition{
      competition_type: :bundesliga
    }

    season = %Season{
      year: 2018
    }

    competition_identifier = "1-bundesliga/spieltag/wettbewerb/L1/plus/0"
    season_year = 2018
    number = 1
    base_url = TMHttpService.base_url()

    expected_url =
      "https://#{base_url}/#{competition_identifier}?saison_id=#{season_year}&spieltag=#{number}"

    with_mock HTTPoison,
      get: fn url ->
        {:ok, result} =
          File.read("./test/simplefootball_web_web/resources/tm/bundesliga_2018_18.html")

        case url do
          ^expected_url -> {:ok, %{body: result}}
          _ -> ""
        end
      end do
      %{matches: matches} = TMMatchdayScraper.matchday(competition, season, number)

      # for more tests see tm_parser_test.exs
      assert length(matches) == 9
    end
  end
end
