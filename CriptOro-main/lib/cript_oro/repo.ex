defmodule CriptOro.Repo do
  use Ecto.Repo,
    otp_app: :cript_oro,
    adapter: Ecto.Adapters.Postgres
end
