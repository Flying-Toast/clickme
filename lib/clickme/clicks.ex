defmodule Clickme.Clicks do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Clickme.{Clicks, Repo}

  schema "clicks" do
    field :num, :decimal
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(clicks, attrs) do
    clicks
    |> cast(attrs, [:num, :title])
    |> validate_required([:num, :title])
    |> validate_length(:title, max: 30)
  end

  def prefill do
    unless Repo.exists?(Clicks) do
      %Clicks{}
      |> changeset(%{num: 0, title: "Edit Me"})
      |> Repo.insert!()
    end
  end

  def get_count do
    Repo.one!(from c in Clicks, select: c.num)
  end

  def get_title do
    Repo.one!(from c in Clicks, select: c.title)
  end

  def persist_count(count) do
    Repo.one!(Clicks)
    |> changeset(%{num: count})
    |> Repo.update!()
  end

  def persist_title(title) do
    Repo.one!(Clicks)
    |> changeset(%{title: title})
    |> Repo.update!()
  end
end
