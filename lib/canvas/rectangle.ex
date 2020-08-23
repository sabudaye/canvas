defmodule Canvas.Rectangle do
  @moduledoc """
  Rectangle struct
  """
  alias __MODULE__
  @default_fill_char " "
  @default_outline_char "x"

  defstruct pos_col: 0, pos_row: 0, width: 1, height: 1, fill_char: @default_fill_char, outline_char: @default_outline_char

  def char_type(row_idx, col_idx, %Rectangle{pos_col: x, pos_row: y, height: h, width: w}) do
    cond do
      (row_idx == y || row_idx == (y + h - 1)) && Enum.member?(x..x+w-1, col_idx) -> :outline
      Enum.member?(y..(y + h - 1), row_idx) && (col_idx == x || col_idx == x+w-1) -> :outline
      Enum.member?(y+1..(y + h - 2), row_idx) && Enum.member?(x+1..x+w-2, col_idx) -> :fill
      true -> :outside
    end
  end
end
