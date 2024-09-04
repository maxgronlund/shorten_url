defmodule ShortenUrlWeb.ActivityController do
  use ShortenUrlWeb, :controller

  alias ShortenUrl.Logs
  alias ShortenUrl.Logs.Activity

  action_fallback ShortenUrlWeb.FallbackController

  def index(conn, _params) do
    activities = Logs.list_activities()
    render(conn, :index, activities: activities)
  end

  def create(conn, %{"activity" => activity_params}) do
    with {:ok, %Activity{} = activity} <- Logs.create_activity(activity_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/activities/#{activity}")
      |> render(:show, activity: activity)
    end
  end
end
