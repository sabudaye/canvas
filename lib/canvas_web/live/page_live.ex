defmodule CanvasWeb.PageLive do
  use CanvasWeb, :live_view

  alias Canvas.Feature.Drawing

  @impl true
  def mount(_params, _session, socket) do
    list = Drawing.all()
    {:ok, assign(socket, :canvases, list)}
  end
end
