defmodule SimplefootballWebWeb.TMHttpServiceTest do
  use SimplefootballWebWeb.ConnCase, async: true

  require Logger

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
end
