defmodule CanvasWeb.CanvasController do
  use CanvasWeb, :controller

  alias Canvas.{Rectangle, CanvasMap}

  def new(conn, _params) do
    canvas = CanvasMap.new()
    render(conn, "canvas.txt", %{canvas: canvas})
  end

  # def show(conn, %{"id" => canvas_id}) do
  #   [{storage, nil}] = Registry.lookup(CanvasStorageRegistry, "canvas#{canvas_id}")
  #   render(conn, "canvas.txt", %{canvas_id: canvas_id, canvas: Storage.value(storage)})
  # end

  def draw_rectangle(conn, params) do
    %{"x" => x, "y" => y, "w" => w, "h" => h, "fc" => fc, "oc" => oc} = params

    rectangle = %Rectangle{
      pos_col: x,
      pos_row: y,
      width: w,
      height: h,
      fill_char: fc,
      outline_char: oc
    }

    canvas = CanvasMap.new()
    new_canvas = CanvasMap.draw(canvas, rectangle)
    render(conn, "canvas.txt", %{canvas: new_canvas})
  end
end
