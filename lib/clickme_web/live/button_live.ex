defmodule ClickmeWeb.ButtonLive do
  use ClickmeWeb, :live_view
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    PubSub.subscribe(Clickme.PubSub, "click_count")

    socket = assign(socket, counter: Clickme.Counter.get_count(), title: Clickme.Counter.get_title())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex justify-center items-center h-full flex-col">
      <div class="-mb-20 mt-6 text-center w-10/12">
        <form phx-change="title_edit">
          <input maxlength="30" name="title" class="font-bold text-xl font-serif rounded-md bg-gray-200 border-2 border-gray-400 text-center w-full" value={@title}/>
        </form>
        <div>(Edit Me)</div>
      </div>
      <div class="my-auto">
        <button phx-click="click" class="bg-gray-200 border-4 border-gray-400 px-10 py-4 text-xl rounded touch-manipulation transition-transform active:scale-95 duration-[35ms]" style="-webkit-tap-highlight-color: transparent;">
          <span class="font-mono font-bold touch-manipulation"><%= @counter %></span>
        </button>
        <div class="text-center">(Click Me)</div>
      </div>
    </div>
    """
  end

  def handle_event("title_edit", %{"title" => newtitle}, socket) do
    Clickme.Counter.set_title(newtitle)
    {:noreply, socket}
  end

  def handle_event("click", _value, socket) do
    Clickme.Counter.increment()
    {:noreply, socket}
  end

  def handle_info(:newclick, socket) do
    {:noreply, update(socket, :counter, &Decimal.add(&1, 1))}
  end

  def handle_info({:title_change, new_title}, socket) do
    {:noreply, assign(socket, :title, new_title)}
  end
end
