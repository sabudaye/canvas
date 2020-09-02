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

  def char_type(char_row, char_col, %Rectangle{} = rectangle) do
    cond do
      top_border(char_row, char_col, rectangle) ->
        :outline

      bottom_border(char_row, char_col, rectangle) ->
        :outline

      left_border(char_row, char_col, rectangle) ->
        :outline

      right_border(char_row, char_col, rectangle) ->
        :outline

      inside(char_row, char_col, rectangle) ->
        :fill

      true ->
        :outside
    end
  end

  defp top_border(char_row, char_col, %Rectangle{pos_col: pos_col, pos_row: pos_row, width: width}) do
    char_row == pos_row && Enum.member?(pos_col..(pos_col + width - 1), char_col)
  end

  defp bottom_border(char_row, char_col, %Rectangle{
         pos_col: pos_col,
         pos_row: pos_row,
         width: width,
         height: height
       }) do
    char_row == pos_row + height - 1 && Enum.member?(pos_col..(pos_col + width - 1), char_col)
  end

  defp left_border(char_row, char_col, %Rectangle{
         pos_col: pos_col,
         pos_row: pos_row,
         height: height
       }) do
    char_col == pos_col && Enum.member?(pos_row..(pos_row + height - 1), char_row)
  end

  defp right_border(char_row, char_col, %Rectangle{
         pos_col: pos_col,
         pos_row: pos_row,
         width: width,
         height: height
       }) do
    char_col == pos_col + width - 1 && Enum.member?(pos_row..(pos_row + height - 1), char_row)
  end

  defp inside(char_row, char_col, %Rectangle{
         pos_col: pos_col,
         pos_row: pos_row,
         width: width,
         height: height
       }) do
    Enum.member?((pos_row + 1)..(pos_row + height - 2), char_row) &&
      Enum.member?((pos_col + 1)..(pos_col + width - 2), char_col)
  end
end
