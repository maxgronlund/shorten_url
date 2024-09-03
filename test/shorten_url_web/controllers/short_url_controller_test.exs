defmodule ShortenUrlWeb.ShortUrlControllerTest do
  use ShortenUrlWeb.ConnCase

  import ShortenUrl.EndpointsFixtures
  alias ShortenUrlWeb.UrlHelper

  # alias ShortenUrl.Endpoints.ShortUrl

  @create_attrs %{
    url: "https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d"
  }
  @invalid_attrs %{url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Redirect to long url" do
    test "When an existing short_url is found", %{conn: conn} do
      short_url =
        short_url_fixture(
          url: "https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d",
          host_port: UrlHelper.host_and_port(conn)
        )

      path = String.slice(short_url.short_url, -6..-1)
      conn = get(conn, ~s"/#{path}")
      location_header = get_resp_header(conn, "location")

      assert conn.status == 301

      assert location_header == [
               "https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d"
             ]
    end

    test "When an existing short_url is not found", %{conn: conn} do
      conn = get(conn, ~s"/not-existing-short-url")
      assert conn.status == 404
    end
  end

  describe "create short_url" do
    test "renders short_url when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/shorten-url/", @create_attrs)
      assert resp = json_response(conn, 200)

      assert %{
               "url" => "https://gist.github.com/aamikkelsenWH/0adb191e365f9e0ed3540e660a1d706d",
               "short_url" => _
             } = resp
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/shorten-url/", @invalid_attrs)
      assert json_response(conn, 422)["errors"] == %{"url" => ["can't be blank"]}
    end
  end
end
