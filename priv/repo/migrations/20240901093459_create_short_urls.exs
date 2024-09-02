defmodule ShortenUrl.Repo.Migrations.CreateShortUrls do
  use Ecto.Migration

  def change do
    create table(:short_urls, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :short_url, :string
      add :url, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:short_urls, [:url])

  end
end
