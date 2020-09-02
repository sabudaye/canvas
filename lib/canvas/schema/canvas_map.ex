defmodule Canvas.Schema.CanvasMap do
  @moduledoc """
  Ecto schema for CanvasMap data structure
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "canvas_map" do
    field :chars, Canvas.Type.CharMap
    field :cols, :integer
    field :fill_char, Canvas.Type.AsciiChar
    field :rows, :integer

    timestamps()
  end

  @doc false
  def changeset(canvas_map, attrs) do
    canvas_map
    |> cast(attrs, [:cols, :rows, :fill_char, :chars])
    |> validate_required([:cols, :rows, :chars])
  end
end
