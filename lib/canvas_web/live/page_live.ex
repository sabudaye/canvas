defmodule CanvasWeb.PageLive do
  use CanvasWeb, :live_view

  alias Canvas.{Rectangle, CanvasMap, FloodFill}

  @impl true
  def mount(_params, _session, socket) do
    canvas = CanvasMap.new()
    {:ok, assign(socket, canvas: canvas)}
  end

  @impl true
  def handle_event(
        "draw_rectangle",
        %{"x" => x, "y" => y, "w" => w, "h" => h, "fc" => fc, "oc" => oc},
        socket
      ) do
    %{canvas: canvas} = socket.assigns

    rectangle = %Rectangle{
      pos_col: String.to_integer(x),
      pos_row: String.to_integer(y),
      width: String.to_integer(w),
      height: String.to_integer(h),
      fill_char: fc,
      outline_char: oc
    }

    new_canvas = CanvasMap.draw(canvas, rectangle)
    {:noreply, assign(socket, :canvas, new_canvas)}
  end

  @impl true
  def handle_event(
        "draw_flood_fiil",
        %{"x" => x, "y" => y, "fc" => fc},
        socket
      ) do
    %{canvas: canvas} = socket.assigns

    flood_fill = %FloodFill{
      pos_col: String.to_integer(x),
      pos_row: String.to_integer(y),
      flood_char: fc,
    }

    new_canvas = CanvasMap.draw(canvas, flood_fill)
    {:noreply, assign(socket, :canvas, new_canvas)}
  end

  @impl true
  def handle_event("reset", _, socket) do
    %{canvas: canvas} = socket.assigns
    {:noreply, assign(socket, :canvas, CanvasMap.reset(canvas))}
  end

  @impl true
  def handle_event("update", _, socket) do
    %{canvas: canvas} = socket.assigns
    {:noreply, assign(socket, :canvas, canvas)}
  end

  def get_char(chars, row, col) do
    Map.get(chars, {row, col})
  end
end
