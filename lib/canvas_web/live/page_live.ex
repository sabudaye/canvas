defmodule CanvasWeb.PageLive do
  use CanvasWeb, :live_view

  alias Canvas.Canvas

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :canvas, Canvas.new())}
  end
end
