defmodule ClickmeWeb.Router do
  use ClickmeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ClickmeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ClickmeWeb do
    pipe_through :browser

    live "/", ButtonLive
  end
end
