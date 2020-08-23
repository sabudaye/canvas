defmodule CanvasWeb.PageLive do
  use CanvasWeb, :live_view

  alias Canvas.Rectangle
  alias Canvas.Matrix

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :canvas, Matrix.new())}
  end

  def get_char(chars, row, col) do
    chars
    |> Enum.at(row)
    |> Enum.at(col)
  end

  @impl true
  def handle_event("draw_rectangle", %{"x" => x, "y" => y, "w" => w, "h" => h, "fc" => fc, "oc" => oc}, socket) do
    %{canvas: canvas} = socket.assigns
    rectangle = %Rectangle{
      pos_col: String.to_integer(x),
      pos_row: String.to_integer(y),
      width: String.to_integer(w),
      height: String.to_integer(h),
      fill_char: fc,
      outline_char: oc
    }
    new_canvas = Matrix.draw(canvas, rectangle)
    {:noreply, assign(socket, :canvas, new_canvas)}
  end

  @impl true
  def handle_event("reset", _, socket) do
    %{canvas: canvas} = socket.assigns
    {:noreply, assign(socket, :canvas, Matrix.reset(canvas))}
  end
end
