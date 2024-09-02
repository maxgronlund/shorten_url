defmodule ShortenUrlWeb.ShortUrlController do
  use ShortenUrlWeb, :controller

  alias ShortenUrl.Endpoints
  alias ShortenUrl.Endpoints.ShortUrl
  alias ShortenUrlWeb.UrlHelper

  action_fallback ShortenUrlWeb.FallbackController

  def create(conn, %{"url" => nil}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: %{url: ["can't be blank"]}})
  end

  def create(conn, %{"url" => url}) do
    short_url_params = %{
      url: url,
      host_port: UrlHelper.host_and_port(conn)
    }

    with {:ok, %ShortUrl{} = short_url} <- Endpoints.find_or_create_short_url(short_url_params) do
      conn
      |> put_resp_header("location", ~p"/#{short_url}")
      |> render(:show, short_url: short_url)
    end
  end

  def show(conn, %{"id" => short_url}) do
    url = UrlHelper.host_port_and_path(conn, short_url)

    case Endpoints.get_short_url(url) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{errors: %{detail: "Not found"}})

      %ShortUrl{url: long_url} ->
        conn
        |> put_status(:moved_permanently)
        |> redirect(external: long_url)
    end
  end
end
