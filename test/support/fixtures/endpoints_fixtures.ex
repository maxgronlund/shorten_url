defmodule ShortenUrl.EndpointsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShortenUrl.Endpoints` context.
  """

  @doc """
  Generate a short_url.
  """
  def short_url_fixture(attrs \\ %{}) do
    {:ok, short_url} =
      attrs
      |> Enum.into(%{
        url: "http://very-long-url.com",
        host_port: "localhost:4000"
      })
      |> ShortenUrl.Endpoints.find_or_create_short_url()

    short_url
  end
end
