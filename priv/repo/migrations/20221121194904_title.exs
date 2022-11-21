defmodule Clickme.Repo.Migrations.Title do
  use Ecto.Migration

  def change do
    alter table(:clicks) do
      add :title, :string, null: false, default: "Edit Me"
    end
  end
end
