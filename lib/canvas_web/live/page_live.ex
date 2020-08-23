defmodule CanvasWeb.PageLive do
  use CanvasWeb, :live_view

  alias Canvas.{Rectangle, Matrix, Counter, Storage}

  @impl true
  def mount(%{"id" => canvas_id}, _session, socket) do
    [{storage, nil}] = Registry.lookup(CanvasStorageRegistry, "canvas#{canvas_id}")
    {:ok, assign(socket, canvas_id: canvas_id, canvas: Storage.value(storage))}
  end

  @impl true
  def mount(_params, _session, socket) do
    canvas_id = Counter.next()
    canvas = Matrix.new()
    {:ok, _pid} = Storage.start_link(canvas, canvas_name(canvas_id))
    {:ok, assign(socket, canvas_id: canvas_id, canvas: canvas)}
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

    [{storage, nil}] = Registry.lookup(CanvasStorageRegistry, "canvas#{canvas_id}")
    canvas = Storage.value(storage)
    new_canvas = Matrix.draw(canvas, rectangle)
    :ok = Storage.update(storage, new_canvas)
    {:noreply, assign(socket, :canvas, new_canvas)}
  end

  @impl true
  def handle_event("reset", _, socket) do
    %{canvas: canvas} = socket.assigns
    {:noreply, assign(socket, :canvas, Matrix.reset(canvas))}
  end

  @impl true
  def handle_event("update", _, socket) do
    %{canvas_id: canvas_id} = socket.assigns
    [{storage, nil}] = Registry.lookup(CanvasStorageRegistry, "canvas#{canvas_id}")
    canvas = Storage.value(storage)
    {:noreply, assign(socket, :canvas, canvas)}
  end

  def get_char(chars, row, col) do
    chars
    |> Enum.at(row)
    |> Enum.at(col)
  end

  defp canvas_name(id) do
    {:via, Registry, {CanvasStorageRegistry, "canvas#{id}"}}
  end
end
