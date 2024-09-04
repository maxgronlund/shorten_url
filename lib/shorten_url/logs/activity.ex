defmodule ShortenUrl.Logs.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :action, :string
    belongs_to :short_url, ShortenUrl.Endpoints.ShortUrl, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:action])
    |> validate_required([:action])
  end
end
