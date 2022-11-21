defmodule Clickme.Repo.Migrations.CreateClicks do
  use Ecto.Migration

  def change do
    create table(:clicks) do
      add :num, :decimal, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
