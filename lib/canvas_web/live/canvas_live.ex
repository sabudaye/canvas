defmodule CanvasWeb.CanvasLive do
  @moduledoc """
  Phoenix Liveview Live controller for canvas show page
  """
  use CanvasWeb, :live_view

  alias Canvas.Feature.Drawing

  @impl true
  def mount(%{"id" => canvas_id}, _session, socket) do
    {:ok, canvas} = Drawing.get(canvas_id)
    Canvas.LiveUpdates.subscribe_live_view(canvas_id)
    {:ok, assign(socket, canvas_id: canvas.id, canvas: canvas)}
  end

  @impl true
  def handle_info(:update, socket) do
    canvas_id = socket.assigns.canvas_id
    {:ok, canvas} = Drawing.get(canvas_id)
    {:noreply, assign(socket, canvas: canvas)}
  end

  def get_char(chars, row, col) do
    Map.get(chars, {row, col})
  end
end
