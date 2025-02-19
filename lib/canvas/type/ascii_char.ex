defmodule Canvas.Type.AsciiChar do
  @moduledoc """
  CharMap ecto data type
  """
  @behaviour Ecto.Type

  import Canvas.Utils

  def type, do: :integer

  def cast(nil), do: :error

  def cast(char) when is_binary(char) do
    if ascii_char?(char) do
      {:ok, char}
    else
      :error
    end
  end

  def cast(_), do: :error

  def dump(val) when is_binary(val), do: {:ok, char_code(val)}

  def dump(_), do: :error

  def load(val) when is_integer(val), do: {:ok, List.to_string([val])}

  def load(_), do: :error

  defp char_code(char), do: hd(String.to_charlist(char))
end
