defmodule Tinypath.Repo do
  use Ecto.Repo,
    otp_app: :tinypath,
    adapter: Ecto.Adapters.Postgres
end
