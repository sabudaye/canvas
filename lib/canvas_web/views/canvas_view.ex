defmodule CanvasWeb.CanvasView do
  use CanvasWeb, :view
  alias Canvas.CanvasMap

  def render("canvas.json", %{canvas_id: id, canvas: %CanvasMap{chars: chars}}) do
    Enum.reduce(chars, "id: #{id}\n", fn row, acc1 ->
      c_row =
        Enum.reduce(row, fn char, acc2 ->
          acc2 <> char
        end)

      acc1 <> c_row <> "\n"
    end)
  end
end
