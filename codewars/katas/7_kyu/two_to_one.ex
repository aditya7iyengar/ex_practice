# Take 2 strings s1 and s2 including only letters from ato z. Return a new sorted string, the longest possible, containing distinct letters, - each taken only once - coming from s1 or s2.

# Examples:

# a = "xyaabbbccccdefww"
# b = "xxxxyyyyabklmopq"
# longest(a, b) -> "abcdefklmopqwxy"

# a = "abcdefghijklmnopqrstuvwxyz"
# longest(a, a) -> "abcdefghijklmnopqrstuvwxyz"

# MY SOLUTION:
defmodule TwoToOne do
  def longest(a, b), do: a |> contained_chars(b)
  defp contained_chars(a, b), do: Enum.filter(chars, &String.contains?(a <> b, &1)) |> Enum.sort |> Enum.join
  defp chars, do: ?a..?z |> Enum.map(&to_string([&1]))
end

# CLEVER SOLUTION:
defmodule TwoToOne do
  def longest(a, b) do
    a <> b |> String.graphemes |> Enum.uniq |> Enum.sort |> Enum.join
  end
end
