defmodule Canvas.Matrix do
  @moduledoc """
  Canvas module with struct and defaults
  """
  alias Canvas.Rectangle
  alias __MODULE__

  @default_cals 32
  @default_rows 12
  @default_fill_char "O"

  defstruct cols: @default_cals, rows: @default_rows, fill_char: @default_fill_char, chars: []

  def new(cols \\ @default_cals, rows \\ @default_rows, fill_char \\ @default_fill_char) do
    chars = reset_chars(cols, rows, fill_char)
    %Matrix{cols: cols, rows: rows, fill_char: fill_char, chars: chars}
  end

  def reset(%Matrix{cols: cols, rows: rows, fill_char: fill_char} = matrix) do
    chars = reset_chars(cols, rows, fill_char)
    %Matrix{matrix | chars: chars}
  end

  def draw(%Matrix{} = matrix, %Rectangle{pos_row: y, height: h} = rectangle) do
    chars =
      Enum.map(0..(matrix.rows - 1), fn row_idx ->
        cond do
          Enum.member?(y..(y + h - 1), row_idx) ->
            redraw_row(Enum.at(matrix.chars, row_idx), row_idx, rectangle)

          true ->
            Enum.at(matrix.chars, row_idx)
        end
      end)

    %Matrix{matrix | chars: chars}
  end

  defp redraw_row(
         chars_row,
         row_idx,
         %Rectangle{outline_char: outline_char, fill_char: fill_char} = rectangle
       ) do
    Enum.map(0..(length(chars_row) - 1), fn col_idx ->
      case Rectangle.char_type(row_idx, col_idx, rectangle) do
        :outline -> outline_char
        :fill -> fill_char
        :outside -> Enum.at(chars_row, col_idx)
      end
    end)
  end

  defp reset_chars(cols, rows, fill_char) do
    fill_char
    |> List.duplicate(cols)
    |> List.duplicate(rows)
  end
end
