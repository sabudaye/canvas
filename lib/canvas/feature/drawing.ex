defmodule Canvas.Feature.Drawing do
  @moduledoc """
  Feature module for drawing on canvas
  """
  alias Canvas.{FloodFill, Rectangle, Repo}
  alias Canvas.Schema.CanvasMap

  import Ecto.Query

  @default_canvas_cols 21
  @default_canvas_rows 8
  @default_canvas_fill_char " "
  @position_range 0..199
  @size_range 1..200
  @ascii_char_codes 32..126

  def all do
    Repo.all(from cm in CanvasMap, select: %{id: cm.id})
  end

  def new(
        rows \\ @default_canvas_rows,
        cols \\ @default_canvas_cols,
        fill_char \\ @default_canvas_fill_char
      ) do
    with {:rows, true} <- {:rows, rows in @size_range},
         {:cols, true} <- {:cols, cols in @size_range},
         {:char, true} <- {:char, ascii_char?(fill_char)} do
      chars = make_chars(rows, cols, fill_char)

      %CanvasMap{}
      |> CanvasMap.changeset(%{cols: cols, rows: rows, fill_char: fill_char, chars: chars})
      |> Repo.insert()
    else
      {:rows, _} -> {:error, "Rows number is out of range (1 to 200)"}
      {:cols, _} -> {:error, "Columns number is out of range (1 to 200)"}
      {:char, _} -> {:error, "#{fill_char} is not a single ASCII char"}
    end
  end

  def get(canvas_id), do: get_canvas(canvas_id)

  def reset(canvas_id) do
    with {:ok, canvas} <- get_canvas(canvas_id) do
      chars = make_chars(canvas.rows, canvas.cols, canvas.fill_char)

      update_canvas(canvas, chars)
    end
  end

  def add_rectangle(
        canvas_id,
        %Rectangle{pos_row: row, pos_col: col, outline_char: oc, fill_char: fc} = rectangle
      ) do
    with {:rows, true} <- {:rows, row in @position_range},
         {:cols, true} <- {:cols, col in @position_range},
         {:char, outline_char, fill_char} <- one_of_either(oc, fc),
         {:char, true} <- {:char, ascii_char?(outline_char)},
         {:char, true} <- {:char, ascii_char?(fill_char)},
         {:ok, canvas} <- get_canvas(canvas_id) do
      chars =
        Enum.map(canvas.chars, fn {{row, col}, _char} = value ->
          case Rectangle.char_type(row, col, rectangle) do
            :outline -> {{row, col}, outline_char}
            :fill -> {{row, col}, fill_char}
            :outside -> value
          end
        end)

      update_canvas(canvas, chars)
    else
      {:rows, _} ->
        {:error, "Row position is out of canvas max size (1 to 200)"}

      {:cols, _} ->
        {:error, "Column position is out of canvas max size (1 to 200)"}

      {:char, :none} ->
        {:error, "One of either fill or outline character should always be present"}

      {:char, _} ->
        {:error, "Outline character and fill character of rectangle must be a single ASCII char"}

      error ->
        error
    end
  end

  def flood_fill(
        canvas_id,
        %FloodFill{pos_row: row, pos_col: col, flood_char: flood_char}
      ) do
    with {:rows, true} <- {:rows, row in @position_range},
         {:cols, true} <- {:cols, col in @position_range},
         {:char, true} <- {:char, ascii_char?(flood_char)},
         {:ok, canvas} <- get_canvas(canvas_id) do
      start = {row, col}
      char_to_replace = Map.get(canvas.chars, start)
      chars = flood(canvas.chars, flood_char, char_to_replace, [start], [])

      update_canvas(canvas, chars)
    else
      {:rows, _} ->
        {:error, "Row position is out of canvas max size (1 to 200)"}

      {:cols, _} ->
        {:error, "Column position is out of canvas max size (1 to 200)"}

      {:char, _} ->
        {:error, "#{flood_char} is not a single ASCII char"}

      error ->
        error
    end
  end

  defp update_canvas(canvas, chars) do
    result =
      canvas
      |> CanvasMap.changeset(%{chars: Map.new(chars)})
      |> Repo.update()

    Canvas.LiveUpdates.notify_live_view(canvas.id)
    result
  end

  defp one_of_either(nil = _outline_char, nil = _fill_char), do: {:char, :none}
  defp one_of_either("" = _outline_char, "" = _fill_char), do: {:char, :none}

  # if not present outline character becomes the same as fill character
  defp one_of_either(nil = _outline_char, fill_char) when is_binary(fill_char),
    do: {:char, fill_char, fill_char}

  defp one_of_either("" = _outline_char, fill_char) when is_binary(fill_char),
    do: {:char, fill_char, fill_char}

  # if not present fill character becomes a space character
  defp one_of_either(outline_char, nil = _fill_char) when is_binary(outline_char),
    do: {:char, outline_char, " "}

  defp one_of_either(outline_char, "" = _fill_char) when is_binary(outline_char),
    do: {:char, outline_char, " "}

  defp one_of_either(outline_char, fill_char)
       when is_binary(outline_char) and is_binary(fill_char),
       do: {:char, outline_char, fill_char}

  defp one_of_either(_, _), do: {:char, :none}

  defp get_canvas(canvas_id) do
    with canvas <- Repo.one(from(cm in CanvasMap, where: cm.id == ^canvas_id)),
         {:canvas, false} <- {:canvas, is_nil(canvas)} do
      {:ok, canvas}
    else
      _ -> {:error, "Canvas #{canvas_id} not found"}
    end
  end

  defp ascii_char?(char) do
    char_codes = String.to_charlist(char)
    length(char_codes) == 1 && hd(char_codes) in @ascii_char_codes
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

  # add up, left, down, right characters to flood
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
