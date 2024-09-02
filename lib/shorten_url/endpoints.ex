defmodule ShortenUrl.Endpoints do
  @moduledoc """
  The Endpoints context.
  """

  import Ecto.Query, warn: false
  alias ShortenUrl.Repo

  alias ShortenUrl.Endpoints.ShortUrl

  @doc """
  Gets a single short_url.

  Raises `Ecto.NoResultsError` if the Short url does not exist.

  ## Examples

      iex> get_short_url!(123)
      %ShortUrl{}

      iex> get_short_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_short_url!(url) do
    Repo.get_by!(ShortUrl, short_url: url)
  end

  def get_short_url(url) do
    Repo.get_by(ShortUrl, short_url: url)
  end

  @doc """
  Creates a short_url.

  ## Examples

      iex> find_or_create_short_url(%{field: value})
      {:ok, %ShortUrl{}}

      iex> find_or_create_short_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def find_or_create_short_url(%{url: nil} = _attrs) do
    {:error, %Ecto.Changeset{}}
  end

  def find_or_create_short_url(%{url: url} = attrs) do
    Repo.get_by(ShortUrl, url: url)
    |> case do
      nil -> create_short_url(attrs)
      short_url -> {:ok, short_url}
    end
  end

  def create_short_url(attrs) do
    %ShortUrl{}
    |> ShortUrl.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking short_url changes.

  ## Examples

      iex> change_short_url(short_url)
      %Ecto.Changeset{data: %ShortUrl{}}

  """
  def change_short_url(%ShortUrl{} = short_url, attrs \\ %{}) do
    ShortUrl.changeset(short_url, attrs)
  end
end
