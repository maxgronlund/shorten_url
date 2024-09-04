defmodule ShortenUrl.EndpointsTest do
  use ShortenUrl.DataCase

  alias ShortenUrl.Endpoints

  describe "short_urls" do
    alias ShortenUrl.Endpoints.ShortUrl

    import ShortenUrl.EndpointsFixtures

    @invalid_attrs %{short_url: nil, url: nil}

    test "get_short_url!/:short_url returns the long_url with given short_url" do
      short_url = short_url_fixture(%{url: "http://another-very-long-url.com"})
      assert Endpoints.get_short_url!(short_url.short_url).id == short_url.id
    end

    test "find_or_create_short_url/1 with valid data creates a short_url" do
      valid_attrs = %{url: "http://a-very-very-long-url.com"}

      assert {:ok, %ShortUrl{} = _stored_short_url} =
               Endpoints.find_or_create_short_url(valid_attrs)
    end

    test "find_or_create_short_url/1 with valid data finds an existing short_url" do
      url = "http://another-very-very-long-url.com"

      short_url = short_url_fixture(%{url: url})

      assert {:ok, %ShortUrl{} = found_short_url} =
               Endpoints.find_or_create_short_url(%{url: url, host_port: "localhost:4000"})

      assert short_url.id == found_short_url.id
    end

    test "find_or_create_short_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Endpoints.find_or_create_short_url(@invalid_attrs)
    end

    test "change_short_url/1 returns a short_url changeset" do
      short_url = short_url_fixture()
      assert %Ecto.Changeset{} = Endpoints.change_short_url(short_url)
    end
  end
end
