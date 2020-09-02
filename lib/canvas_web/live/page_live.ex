defmodule CanvasWeb.PageLive do
  @moduledoc """
  Phoenix Liveview Live controller for root index page
  """
  use CanvasWeb, :live_view

  alias Canvas.Feature.Drawing

  @impl true
  def mount(_params, _session, socket) do
    list = Drawing.all()
    {:ok, assign(socket, :canvases, list)}
  end
end
