defmodule ShortenUrlWeb.ShortUrlController do
  use ShortenUrlWeb, :controller

  alias ShortenUrl.Endpoints
  alias ShortenUrl.Endpoints.ShortUrl
  alias ShortenUrlWeb.UrlHelper

  action_fallback ShortenUrlWeb.FallbackController

  # def index(conn, _params) do
  #   short_urls = Endpoints.list_short_urls()
  #   render(conn, :index, short_urls: short_urls)
  # end

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

  # defp host_port(conn) do
  #   conn.host <> ":" <> Integer.to_string(conn.port)
  # end

  # defp prepend_host_port(host_port, short_url) do
  #   ShortUrl.prepend_host_port(short_url, host_port)
  # end

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

  # def update(conn, %{"id" => id, "short_url" => short_url_params}) do
  #   short_url = Endpoints.get_short_url!(id)

  #   with {:ok, %ShortUrl{} = short_url} <- Endpoints.update_short_url(short_url, short_url_params) do
  #     render(conn, :show, short_url: short_url)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   short_url = Endpoints.get_short_url!(id)

  #   with {:ok, %ShortUrl{}} <- Endpoints.delete_short_url(short_url) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
