defmodule Clickme.Clicks do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Clickme.{Clicks, Repo}

  schema "clicks" do
    field :num, :decimal

    timestamps(type: :utc_datetime)
  end

  def changeset(clicks, attrs) do
    clicks
    |> cast(attrs, [:num])
    |> validate_required([:num])
  end

  def prefill do
    unless Repo.exists?(Clicks) do
      %Clicks{}
      |> changeset(%{num: 0})
      |> Repo.insert!()
    end
  end

  def get_count do
    Repo.one!(from c in Clicks, select: c.num)
  end

  def persist(count) do
    Repo.one!(Clicks)
    |> changeset(%{num: count})
    |> Repo.update!()
  end
end
