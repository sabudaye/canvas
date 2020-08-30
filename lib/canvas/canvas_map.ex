defmodule Canvas.CanvasMap do
  @moduledoc """
  Canvas module with struct and defaults
  """
  alias Canvas.{Rectangle, FloodFill}
  alias __MODULE__

  @default_cols 21
  @default_rows 8
  @default_fill_char " "

  defstruct cols: @default_cols, rows: @default_rows, fill_char: @default_fill_char, chars: []

  def new(rows \\ @default_rows, cols \\ @default_cols, fill_char \\ @default_fill_char) do
    chars = make_chars(rows, cols, fill_char)
    %CanvasMap{cols: cols, rows: rows, fill_char: fill_char, chars: chars}
  end

  def reset(%CanvasMap{cols: cols, rows: rows, fill_char: fill_char} = canvas_map) do
    chars = make_chars(rows, cols, fill_char)
    %CanvasMap{canvas_map | chars: chars}
  end

  def draw(
        %CanvasMap{chars: chars} = canvas_map,
        %Rectangle{outline_char: oc, fill_char: fc} = rectangle
      ) do
    chars =
      Enum.map(chars, fn {{row, col}, _char} = value ->
        case Rectangle.char_type(row, col, rectangle) do
          :outline -> {{row, col}, oc}
          :fill -> {{row, col}, fc}
          :outside -> value
        end
      end)

    %CanvasMap{canvas_map | chars: Map.new(chars)}
  end

  def draw(
        %CanvasMap{chars: chars} = canvas_map,
        %FloodFill{pos_row: row, pos_col: col, flood_char: flood_char}
      ) do
    start = {row, col}
    char_to_replace = Map.get(chars, start)

    chars = flood(canvas_map.chars, flood_char, char_to_replace, [start], [])

    %CanvasMap{canvas_map | chars: Map.new(chars)}
  end

  defp flood(chars, _flood_char, _char_to_replace, [], _touched_chars) do
    chars
  end

  defp flood(chars, flood_char, char_to_replace, [key | next_chars], touched_chars) do
    if Map.has_key?(chars, key) && char_to_replace == Map.get(chars, key) do
      new_chars = Map.replace!(chars, key, flood_char)

      flood(
        new_chars,
        flood_char,
        char_to_replace,
        add_next_chars(key, next_chars, touched_chars),
        [key | touched_chars]
      )
    else
      flood(chars, flood_char, char_to_replace, next_chars, [key | touched_chars])
    end
  end

  defp add_next_chars({row, col}, next_chars, touched_chars) do
    to_add = [{row - 1, col}, {row, col - 1}, {row + 1, col}, {row, col + 1}]

    to_add =
      Enum.reject(to_add, fn key ->
        Enum.member?(touched_chars, key) || Enum.member?(next_chars, key)
      end)

    to_add ++ next_chars
  end

  defp make_chars(rows, cols, fill_char) do
    Enum.reduce(0..(rows - 1), %{}, fn row, acc ->
      Enum.reduce(0..(cols - 1), acc, fn col, acc ->
        Map.put(acc, {row, col}, fill_char)
      end)
    end)
  end
end
