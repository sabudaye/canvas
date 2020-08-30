defmodule Canvas.FloodFill do
  @moduledoc """
  FloodFill struct
  """
  @default_flood_char "O"

  defstruct pos_col: 0,
            pos_row: 0,
            flood_char: @default_flood_char
end
