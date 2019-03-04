defmodule SimplefootballWebWeb.Router do
  use SimplefootballWebWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", SimplefootballWebWeb do
    pipe_through :api

    resources "/competitions", CompetitionController, only: [:index]
  end
end
