defmodule ShortenUrlWeb.UrlHelperTest do
  use ShortenUrlWeb.ConnCase

  describe "host_port_and_path" do
    test "returns host, port and path" do
      conn = build_conn()
      short_path = "f0a0S0"

      assert ShortenUrlWeb.UrlHelper.host_port_and_path(conn, short_path) ==
               "www.example.com:80/#{short_path}"
    end
  end
end
