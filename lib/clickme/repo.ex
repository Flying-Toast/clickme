defmodule Clickme.Repo do
  use Ecto.Repo,
    otp_app: :clickme,
    adapter: Ecto.Adapters.SQLite3
end
