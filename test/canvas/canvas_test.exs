defmodule Canvas.MatrixTest do
  use ExUnit.Case
  alias Canvas.Rectangle
  alias Canvas.Matrix

  test "new/0 returns matrix of default size with default fill char" do
    canvas = Matrix.new()
    assert canvas.rows == 12
    assert canvas.cols == 32
    assert length(canvas.chars) == 12
    assert Enum.at(canvas.chars, 0) == List.duplicate(canvas.fill_char, canvas.cols)
  end

  test "draw/2 draws rectangle on canvas" do
    rectangle = %Rectangle{pos_row: 1, pos_col: 1, width: 10, height: 10, fill_char: "X", outline_char: "Y"}
    canvas = Matrix.draw(Matrix.new(), rectangle)
    assert count_chars(canvas.chars, "Y") == 36
    assert count_chars(canvas.chars, "X") == 64
  end

  test "reset/1 cleans up the canvas to default state" do
    rectangle = %Rectangle{pos_row: 1, pos_col: 1, width: 10, height: 10, fill_char: "X", outline_char: "Y"}
    canvas = Matrix.draw(Matrix.new(), rectangle)
    assert count_chars(canvas.chars, "Y") == 36
    canvas = Matrix.reset(canvas)
    assert count_chars(canvas.chars, "Y") == 0
  end

  def count_chars(chars, char) do
    chars
    |> Enum.flat_map(fn ch -> ch end)
    |> Enum.filter(fn ch -> ch == char end)
    |> Enum.count()
  end
end
