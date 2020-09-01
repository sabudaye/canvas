defmodule CanvasWeb.PageLive do
  use CanvasWeb, :live_view

  alias Canvas.{Rectangle, FloodFill}
  alias Canvas.Feature.Drawing

  @impl true
  def mount(%{"id" => canvas_id}, _session, socket) do
    {:ok, canvas} = Drawing.get(canvas_id)
    {:ok, assign(socket, canvas_id: canvas.id, canvas: canvas)}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, canvas} = Drawing.new()
    {:ok, assign(socket, canvas_id: canvas.id, canvas: canvas)}
  end

  @impl true
  def handle_event(
        "draw_rectangle",
        %{"x" => x, "y" => y, "w" => w, "h" => h, "fc" => fc, "oc" => oc},
        socket
      ) do
    %{canvas_id: canvas_id} = socket.assigns

    rectangle = %Rectangle{
      pos_col: String.to_integer(x),
      pos_row: String.to_integer(y),
      width: String.to_integer(w),
      height: String.to_integer(h),
      fill_char: fc,
      outline_char: oc
    }

    {:ok, new_canvas} = Drawing.add_rectangle(canvas_id, rectangle)
    {:noreply, assign(socket, :canvas, new_canvas)}
  end

  @impl true
  def handle_event(
        "draw_flood_fiil",
        %{"x" => x, "y" => y, "fc" => fc},
        socket
      ) do
    %{canvas_id: canvas_id} = socket.assigns

    flood_fill = %FloodFill{
      pos_col: String.to_integer(x),
      pos_row: String.to_integer(y),
      flood_char: fc
    }

    {:ok, new_canvas} = Drawing.flood_fill(canvas_id, flood_fill)
    {:noreply, assign(socket, :canvas, new_canvas)}
  end

  @impl true
  def handle_event("reset", _, socket) do
    %{canvas_id: canvas_id} = socket.assigns
    {:ok, canvas} = Drawing.reset(canvas_id)
    {:noreply, assign(socket, :canvas, canvas)}
  end

  @impl true
  def handle_event("update", _, socket) do
    %{canvas_id: canvas_id} = socket.assigns
    {:ok, canvas} = Drawing.get(canvas_id)
    {:noreply, assign(socket, :canvas, canvas)}
  end

  def get_char(chars, row, col) do
    Map.get(chars, {row, col})
  end
end
