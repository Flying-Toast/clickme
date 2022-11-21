defmodule ClickmeWeb.ButtonLive do
  use ClickmeWeb, :live_view
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    PubSub.subscribe(Clickme.PubSub, "click_count")

    {:ok, assign(socket, :counter, Clickme.Counter.get_count())}
  end

  def render(assigns) do
    ~H"""
    <button phx-click="click" class="bg-gray-200 border-4 border-gray-400 px-10 py-4 text-xl rounded touch-manipulation transition-transform active:scale-95 duration-[35ms]" style="-webkit-tap-highlight-color: transparent;">
      <span class="font-mono font-bold touch-manipulation"><%= @counter %></span>
    </button>
    """
  end

  def handle_event("click", _value, socket) do
    Clickme.Counter.increment()
    {:noreply, socket}
  end

  def handle_info(:newclick, socket) do
    {:noreply, update(socket, :counter, &Decimal.add(&1, 1))}
  end
end
