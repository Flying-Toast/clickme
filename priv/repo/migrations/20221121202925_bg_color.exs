defmodule Clickme.Repo.Migrations.BgColor do
  use Ecto.Migration

  def change do
    alter table(:clicks) do
      add :bg_color, :string, default: "#fffff", null: false
    end
  end
end
