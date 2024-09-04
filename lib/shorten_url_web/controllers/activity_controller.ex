defmodule ShortenUrlWeb.ActivityController do
  use ShortenUrlWeb, :controller

  alias ShortenUrl.Logs

  action_fallback ShortenUrlWeb.FallbackController

  def index(conn, _params) do
    activities = Logs.list_activities()
    render(conn, :index, activities: activities)
  end
end
