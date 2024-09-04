defmodule ShortenUrl.Endpoints.ShortUrl do
  use Ecto.Schema
  import Ecto.Changeset

  alias ShortenUrl.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "short_urls" do
    field :url, :string
    field :short_url, :string

    has_many :activities, ShortenUrl.Logs.Activity,
      foreign_key: :short_url_id,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(short_url, params) do
    host_port = params[:host_port]

    attrs = %{
      short_url: generate_unique_shorten_url(host_port),
      url: params[:url]
    }

    short_url
    |> cast(attrs, [:short_url, :url])
    |> validate_required([:short_url, :url])
    |> unique_constraint(:url)
    |> put_assoc(:activities, [build_activity()])
  end

  defp build_activity() do
    %ShortenUrl.Logs.Activity{
      action: "create"
    }
  end

  defp generate_unique_shorten_url(host_port, length \\ 6) do
    short_url = generate_shorten_url(host_port, length)

    if ShortenUrl.Endpoints.ShortUrl |> Repo.get_by(short_url: short_url) do
      generate_unique_shorten_url(host_port, length)
    else
      short_url
    end
  end

  defp generate_shorten_url(host_port, length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64()
    |> binary_part(0, length)
    |> prepend_host_port(host_port)
  end

  def prepend_host_port(short_url, host_port) do
    "#{host_port}/#{short_url}"
  end
end
