defmodule CanvasWeb.PageLiveTest do
  use CanvasWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")
    assert render(page_live) =~ "Update"
    assert render(page_live) =~ "Draw"
    assert render(page_live) =~ "Reset"
  end
end
