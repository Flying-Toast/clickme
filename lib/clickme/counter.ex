defmodule Clickme.Counter do
  use GenServer
  alias Phoenix.PubSub
  alias Clickme.Clicks

  def start_link(_args) do
    Clicks.prefill()

    GenServer.start_link(__MODULE__, %{count: Clicks.get_count(), title: Clicks.get_title()}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:inc, state) do
    state = %{state | count: Decimal.add(state.count, 1)}
    PubSub.broadcast(Clickme.PubSub, "click_count", :newclick)
    if Decimal.rem(state.count, 100) |> Decimal.eq?(0) do
      Clicks.persist_count(state.count)
    end

    {:noreply, state}
  end

  @impl true
  def handle_call(:get_count, _from, state) do
    {:reply, state.count, state}
  end

  @impl true
  def handle_call(:get_title, _from, state) do
    {:reply, state.title, state}
  end

  @impl true
  def handle_cast({:set_title, new_title}, state) do
    PubSub.broadcast(Clickme.PubSub, "click_count", {:title_change, new_title})
    Clicks.persist_title(new_title)
    {:noreply, %{state | title: new_title}}
  end

  def increment() do
    GenServer.cast(__MODULE__, :inc)
  end

  def set_title(new_title) do
    GenServer.cast(__MODULE__, {:set_title, new_title})
  end

  def get_count() do
    GenServer.call(__MODULE__, :get_count)
  end

  def get_title() do
    GenServer.call(__MODULE__, :get_title)
  end
end
