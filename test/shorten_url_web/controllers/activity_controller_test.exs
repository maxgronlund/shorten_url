defmodule ShortenUrlWeb.ActivityControllerTest do
  use ShortenUrlWeb.ConnCase

  import ShortenUrl.LogsFixtures

  alias ShortenUrl.Logs.Activity

  @create_attrs %{
    action: "some action"
  }
  @update_attrs %{
    action: "some updated action"
  }
  @invalid_attrs %{action: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all activities", %{conn: conn} do
      conn = get(conn, ~p"/activities")
      assert json_response(conn, 200)["data"] == []
    end
  end





  defp create_activity(_) do
    activity = activity_fixture()
    %{activity: activity}
  end
end
