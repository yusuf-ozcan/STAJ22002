defmodule CriptOroWeb.PageController do
  use CriptOroWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
