defmodule Canvas.Repo.Migrations.CreateCanvasMap do
  use Ecto.Migration

  def change do
    create table(:canvas_map) do
      add :cols, :integer
      add :rows, :integer
      add :fill_char, :integer
      add :chars, :binary

      timestamps()
    end
  end
end
