defmodule SimplefootballWebWeb.PageController do
  use SimplefootballWebWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
