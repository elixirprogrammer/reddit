defmodule Reddit.Repo do
  use Ecto.Repo,
    otp_app: :reddit,
    adapter: Ecto.Adapters.Postgres
end
