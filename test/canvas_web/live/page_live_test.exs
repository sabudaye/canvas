defmodule CanvasWeb.PageLiveTest do
  use CanvasWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders main page", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")
  end
end
