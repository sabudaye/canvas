defmodule CanvasWeb.CanvasView do
  use CanvasWeb, :view
  alias Canvas.Matrix

  def render("canvas.txt", %{canvas_id: id, canvas: %Matrix{chars: chars}}) do
    Enum.reduce(chars, "id: #{id}\n", fn row, acc1 ->
      c_row =
        Enum.reduce(row, fn char, acc2 ->
          acc2 <> char
        end)

      acc1 <> c_row <> "\n"
    end)
  end
end
