defmodule Canvas.Type.CharMap do
  @moduledoc """
  CharMap ecto data type
  """
  @behaviour Ecto.Type

  import Canvas.Utils

  def type, do: :binary

  def cast(nil), do: :error

  def cast(chars) when is_map(chars) do
    if Enum.all?(chars, &valid_char_map_item?/1), do: {:ok, chars}, else: :error
  end

  def cast(_), do: :error

  def dump(val) when is_map(val), do: {:ok, :erlang.term_to_binary(val)}

  def dump(_), do: :error

  def load(val) when is_binary(val), do: {:ok, :erlang.binary_to_term(val)}

  def load(_), do: :error

  defp valid_char_map_item?({{x, y}, v})
       when is_number(x) and is_number(y) and x >= 0 and y >= 0 do
    ascii_char?(v)
  end

  defp valid_char_map_item?(_), do: false
end
