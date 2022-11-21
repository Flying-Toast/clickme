defmodule Clickme.Clicks do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Clickme.{Clicks, Repo}

  schema "clicks" do
    field :num, :decimal
    field :title, :string
    field :bg_color, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(clicks, attrs) do
    clicks
    |> cast(attrs, [:num, :title, :bg_color])
    |> validate_required([:num, :title, :bg_color])
    |> validate_length(:title, max: 150)
    |> validate_format(:bg_color, ~r/#[0-9a-f]{6}/)
  end

  def prefill do
    unless Repo.exists?(Clicks) do
      %Clicks{}
      |> changeset(%{num: 0, title: "Edit Me", bg_color: "#ffffff"})
      |> Repo.insert!()
    end
  end

  def get_count do
    Repo.one!(from c in Clicks, select: c.num)
  end

  def get_title do
    Repo.one!(from c in Clicks, select: c.title)
  end

  def get_bg_color do
    Repo.one!(from c in Clicks, select: c.bg_color)
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

  def persist_bg_color(color) do
    Repo.one!(Clicks)
    |> changeset(%{bg_color: color})
    |> Repo.update!()
  end
end
