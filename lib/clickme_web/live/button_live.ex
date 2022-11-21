defmodule ClickmeWeb.ButtonLive do
  use ClickmeWeb, :live_view
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    PubSub.subscribe(Clickme.PubSub, "click_count")

    socket = assign(
      socket,
      counter: Clickme.Counter.get_count(),
      title: Clickme.Counter.get_title(),
      bg_color: Clickme.Counter.get_bg_color()
    )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div style={ "background-color: #{@bg_color};"} class="flex justify-center items-center h-full flex-col">
      <div class="-mb-20 mt-6 text-center w-10/12">
        <form phx-change="title_edit">
          <input maxlength="150" name="title" class="font-bold text-xl font-serif rounded-md bg-gray-200 border-2 border-gray-400 text-center w-full" value={@title}/>
        </form>
        <div class="invert-text">(Edit Me)</div>
      </div>
      <div class="my-auto">
        <button phx-click="click" class="bg-gray-200 border-4 border-gray-400 px-10 py-4 text-xl rounded touch-manipulation transition-transform active:scale-95 duration-[35ms]" style="-webkit-tap-highlight-color: transparent;">
          <span class="font-mono font-bold touch-manipulation"><%= @counter %></span>
        </button>
        <div class="text-center invert-text">(Click Me)</div>
      </div>

      <form phx-change="color_change" class="text-center self-end mr-2 mb-1">
        <input class="border-2 border-black" type="color" name="bg_color" value={@bg_color}>
        <div class="invert-text">(Change Me)</div>
      </form>
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

  def handle_event("color_change", %{"bg_color" => color}, socket) do
    Clickme.Counter.set_bg_color(color)
    {:noreply, socket}
  end

  def handle_info(:newclick, socket) do
    {:noreply, update(socket, :counter, &Decimal.add(&1, 1))}
  end

  def handle_info({:title_change, new_title}, socket) do
    {:noreply, assign(socket, :title, new_title)}
  end

  def handle_info({:bg_color, color}, socket) do
    {:noreply, assign(socket, :bg_color, color)}
  end
end
