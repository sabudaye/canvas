defmodule CanvasWeb.CanvasView do
  use CanvasWeb, :view
  alias __MODULE__

  def render("show.json", %{canvas: canvas}) do
    %{data: render_one(canvas, CanvasView, "canvas.json")}
  end

  def render("canvas.json", %{canvas: canvas}) do
    chars =
      Enum.reduce(canvas.chars, %{}, fn {{x, y}, val}, acc ->
        key_x = Integer.to_string(x)
        key_y = Integer.to_string(y)

        if Map.has_key?(acc, key_x) do
          put_in(acc, [key_x, key_y], val)
        else
          Map.put_new(acc, key_x, %{key_y => val})
        end
      end)

    %{id: canvas.id, rows: canvas.rows, cols: canvas.cols, chars: chars}
  end

  def render("error.json", _) do
    %{error: "paramteres are incorrect"}
  end
end
