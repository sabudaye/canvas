defmodule CanvasWeb.CanvasController do
  use CanvasWeb, :controller

  alias Canvas.{Rectangle, Matrix, Counter, Storage}

  def new(conn, _params) do
    canvas_id = Counter.next()
    canvas = Matrix.new()
    {:ok, _pid} = Storage.start_link(canvas, canvas_name(canvas_id))
    render(conn, "canvas.txt", %{canvas_id: canvas_id, canvas: canvas})
  end

  def show(conn, %{"id" => canvas_id}) do
    [{storage, nil}] = Registry.lookup(CanvasStorageRegistry, "canvas#{canvas_id}")
    render(conn, "canvas.txt", %{canvas_id: canvas_id, canvas: Storage.value(storage)})
  end

  def draw_rectangle(conn, %{"id" => canvas_id} = params) do
    %{"x" => x, "y" => y, "w" => w, "h" => h, "fc" => fc, "oc" => oc} = params

    rectangle = %Rectangle{
      pos_col: x,
      pos_row: y,
      width: w,
      height: h,
      fill_char: fc,
      outline_char: oc
    }

    [{storage, nil}] = Registry.lookup(CanvasStorageRegistry, "canvas#{canvas_id}")
    canvas = Storage.value(storage)
    new_canvas = Matrix.draw(canvas, rectangle)
    :ok = Storage.update(storage, new_canvas)
    render(conn, "canvas.txt", %{canvas_id: canvas_id, canvas: new_canvas})
  end

  defp canvas_name(id) do
    {:via, Registry, {CanvasStorageRegistry, "canvas#{id}"}}
  end
end
