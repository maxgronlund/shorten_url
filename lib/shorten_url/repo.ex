defmodule ShortenUrl.Repo do
  use Ecto.Repo,
    otp_app: :shorten_url,
    adapter: Ecto.Adapters.Postgres
end
