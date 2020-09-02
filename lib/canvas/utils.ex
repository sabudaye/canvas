defmodule Canvas.Utils do
  @ascii_char_codes 32..126

  def ascii_char?(char) do
    char_codes = String.to_charlist(char)
    length(char_codes) == 1 && hd(char_codes) in @ascii_char_codes
  end
end
