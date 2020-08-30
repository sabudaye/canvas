defmodule Canvas.Rectangle do
  @moduledoc """
  Rectangle struct
  """
  alias __MODULE__

  defstruct pos_col: 0,
            pos_row: 0,
            width: 1,
            height: 1,
            fill_char: nil,
            outline_char: nil

  def char_type(row, col, %Rectangle{pos_col: x, pos_row: y, height: h, width: w}) do
    cond do
      (row == y || row == y + h - 1) && Enum.member?(x..(x + w - 1), col) ->
        :outline

      (col == x || col == x + w - 1) && Enum.member?(y..(y + h - 1), row) ->
        :outline

      Enum.member?((y + 1)..(y + h - 2), row) && Enum.member?((x + 1)..(x + w - 2), col) ->
        :fill

      true ->
        :outside
    end
  end
end
