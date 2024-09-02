defmodule ShortenUrlWeb.ShortUrlControllerTest do
  use ShortenUrlWeb.ConnCase

  import ShortenUrl.EndpointsFixtures
  alias ShortenUrlWeb.UrlHelper

  # alias ShortenUrl.Endpoints.ShortUrl

  @create_attrs %{
    url: "http://very-long-url.com"
  }
  # @update_attrs %{
  #   short: "some updated short",
  #   url: "some updated long"
  # }
  @invalid_attrs %{url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "index" do
  #   test "lists all short_urls", %{conn: conn} do
  #     conn = get(conn, ~p"/api/short_urls")
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  describe "Redirect to long url" do
    test "When an existing short_url is found", %{conn: conn} do
      short_url =
        short_url_fixture(url: "https://www.google.com", host_port: UrlHelper.host_and_port(conn))

      path = String.slice(short_url.short_url, -6..-1)
      conn = get(conn, ~s"/#{path}")
      location_header = get_resp_header(conn, "location")

      assert conn.status == 301
      assert location_header == ["https://www.google.com"]
    end

    test "When an existing short_url is not found", %{conn: conn} do
      conn = get(conn, ~s"/not-existing-short-url")
      assert conn.status == 404
    end
  end

  describe "create short_url" do
    test "renders short_url when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/", @create_attrs)
      assert resp = json_response(conn, 200)

      assert %{
               "url" => "http://very-long-url.com",
               "short_url" => _short_url
             } = resp
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/", @invalid_attrs)
      assert json_response(conn, 422)["errors"] == %{"url" => ["can't be blank"]}
    end
  end

  # describe "update short_url" do
  #   setup [:find_or_create_short_url]

  #   test "renders short_url when data is valid", %{
  #     conn: conn,
  #     short_url: %ShortUrl{id: id} = short_url
  #   } do
  #     conn = put(conn, ~p"/api/short_urls/#{short_url}", short_url: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, ~p"/api/short_urls/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "long" => "some updated long",
  #              "short" => "some updated short"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, short_url: short_url} do
  #     conn = put(conn, ~p"/api/short_urls/#{short_url}", short_url: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete short_url" do
  #   setup [:find_or_create_short_url]

  #   test "deletes chosen short_url", %{conn: conn, short_url: short_url} do
  #     conn = delete(conn, ~p"/api/short_urls/#{short_url}")
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/api/short_urls/#{short_url}")
  #     end
  #   end
  # end

  # defp find_or_create_short_url(_) do
  #   short_url = short_url_fixture()
  #   %{short_url: short_url}
  # end
end
