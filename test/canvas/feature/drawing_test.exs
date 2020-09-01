defmodule Canvas.Feature.DrawingTest do
  use Canvas.DataCase
  alias Canvas.{Rectangle, FloodFill}
  alias Canvas.Feature.Drawing

  test "new/0 returns map with {x, y} as keys and fill char as value" do
    {:ok, canvas} = Drawing.new(3, 3, " ")
    assert canvas.rows == 3
    assert canvas.cols == 3

    expected_map = %{
      {0, 0} => " ",
      {0, 1} => " ",
      {0, 2} => " ",
      {1, 0} => " ",
      {1, 1} => " ",
      {1, 2} => " ",
      {2, 0} => " ",
      {2, 1} => " ",
      {2, 2} => " "
    }

    assert ^expected_map = canvas.chars
  end

  test "draw/2 draws rectangle on canvas" do
    rectangle = %Rectangle{
      pos_row: 0,
      pos_col: 0,
      width: 2,
      height: 2,
      fill_char: "Y",
      outline_char: "X"
    }

    {:ok, canvas} = Drawing.new(3, 3, " ")
    {:ok, new_canvas} = Drawing.add_rectangle(canvas.id, rectangle)

    expected_map = %{
      {0, 0} => "X",
      {0, 1} => "X",
      {0, 2} => " ",
      {1, 0} => "X",
      {1, 1} => "X",
      {1, 2} => " ",
      {2, 0} => " ",
      {2, 1} => " ",
      {2, 2} => " "
    }

    assert ^expected_map = new_canvas.chars
  end

  test "draw/2 draws rectangle with fill chars on canvas" do
    rectangle = %Rectangle{
      pos_row: 0,
      pos_col: 0,
      width: 3,
      height: 3,
      fill_char: "Y",
      outline_char: "X"
    }

    {:ok, canvas} = Drawing.new(3, 3, " ")
    {:ok, new_canvas} = Drawing.add_rectangle(canvas.id, rectangle)

    expected_map = %{
      {0, 0} => "X",
      {0, 1} => "X",
      {0, 2} => "X",
      {1, 0} => "X",
      {1, 1} => "Y",
      {1, 2} => "X",
      {2, 0} => "X",
      {2, 1} => "X",
      {2, 2} => "X"
    }

    assert ^expected_map = new_canvas.chars
  end

  test "draw/2 draws flood fill on canvas" do
    rectangle = %Rectangle{
      pos_row: 1,
      pos_col: 1,
      width: 3,
      height: 3,
      fill_char: "Y",
      outline_char: "X"
    }

    flood_fill = %FloodFill{
      pos_row: 0,
      pos_col: 0,
      flood_char: "O"
    }

    {:ok, canvas} = Drawing.new(5, 4, " ")
    {:ok, canvas} = Drawing.add_rectangle(canvas.id, rectangle)
    {:ok, new_canvas} = Drawing.flood_fill(canvas.id, flood_fill)

    expected_map = %{
      {0, 0} => "O",
      {0, 1} => "O",
      {0, 2} => "O",
      {0, 3} => "O",
      {1, 0} => "O",
      {1, 1} => "X",
      {1, 2} => "X",
      {1, 3} => "X",
      {2, 0} => "O",
      {2, 1} => "X",
      {2, 2} => "Y",
      {2, 3} => "X",
      {3, 0} => "O",
      {3, 1} => "X",
      {3, 2} => "X",
      {3, 3} => "X",
      {4, 0} => "O",
      {4, 1} => "O",
      {4, 2} => "O",
      {4, 3} => "O"
    }

    assert ^expected_map = new_canvas.chars
  end
end
