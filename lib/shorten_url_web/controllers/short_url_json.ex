defmodule ShortenUrlWeb.ShortUrlJSON do
  alias ShortenUrl.Endpoints.ShortUrl

  @doc """
  Renders a list of short_urls.
  """
  def index(%{short_urls: short_urls}) do
    %{data: for(short_url <- short_urls, do: data(short_url))}
  end

  @doc """
  Renders a single short_url.
  """
  def show(%{short_url: short_url}) do
    data(short_url)
  end

  defp data(%ShortUrl{} = short_url) do
    %{
      short_url: short_url.short_url,
      url: short_url.url
    }
  end
end
