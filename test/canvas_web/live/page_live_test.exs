defmodule CanvasWeb.PageLiveTest do
  use CanvasWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Canvas size"
    assert render(page_live) =~ "Canvas size"
    assert render(page_live) =~ "Draw"
    assert render(page_live) =~ "Reset"
  end
end
