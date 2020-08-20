defmodule Canvas.Canvas do
  @moduledoc """
  Canvas struct with defaults
  """
  alias __MODULE__

  @default_cals 32
  @default_rows 12
  @default_fill_char " "

  defstruct cols: @default_cals, rows: @default_rows, fill_char: @default_fill_char, chars: []

  @spec new(integer, integer, any) :: Canvas.Canvas.t()
  def new(cols \\ @default_cals, rows \\ @default_rows , fill_char \\ @default_fill_char) do
    chars = List.duplicate(fill_char, cols * rows)
    %Canvas{cols: cols, rows: rows, fill_char: fill_char, chars: chars}
  end
end
