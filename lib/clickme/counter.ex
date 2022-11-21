defmodule Clickme.Counter do
  use GenServer
  alias Phoenix.PubSub
  alias Clickme.Clicks

  def start_link(_args) do
    Clicks.prefill()

    GenServer.start_link(__MODULE__, Clicks.get_count(), name: __MODULE__)
  end

  @impl true
  def init(count) do
    {:ok, count}
  end

  @impl true
  def handle_cast(:inc, count) do
    count = Decimal.add(count, 1)
    PubSub.broadcast(Clickme.PubSub, "click_count", :newclick)
    if Decimal.rem(count, 100) |> Decimal.eq?(0) do
      Clicks.persist(count)
    end

    {:noreply, count}
  end

  @impl true
  def handle_call(:get, _from, count) do
    {:reply, count, count}
  end

  def increment() do
    GenServer.cast(__MODULE__, :inc)
  end

  def get_count() do
    GenServer.call(__MODULE__, :get)
  end
end
