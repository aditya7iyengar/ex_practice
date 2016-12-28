# You are given a string s made up of substring s(1), s(2), ..., s(n) separated by whitespaces. Example: "after be arrived two My so"

# Task

# Return a string t having the following property:

# length t(O) <= length t(1) >= length t(2) <= length t(3) >= length t(4) .... (P)

# where the t(i) are the substring of s; you must respect the following rule:

# at each step from left to right, you can only move either already consecutive strings or strings that became consecutive after a previous move. The number of moves should be minimum.

# Let us go with our example:

# The length of "after" is greater than the length of "be". Let us move them ->"be after arrived two My so"

# The length of "after" is smaller than the length of "arrived". Let us move them -> "be arrived after two My so"

# The length of "after" is greater than the length of "two" ->"be arrived two after My so"

# The length of "after" is greater than the length of "My". Good! Finally the length of "My" and "so" are the same, nothing to do. At the end of the process, the substrings s(i) verify:

# length s(0) <= length s(1) >= length s(2) <= length s(3) >= length (s4) <= length (s5)

# Hence given a string s of substrings s(i) the function arrange with the previous process should return a unique string t having the property (P).

# It is kind of roller coaster or up and down. When you have property (P), to make the result more "up and down" visible t(0), t(2), ... will be lower cases and the others upper cases.

# arrange("after be arrived two My so") should return "be ARRIVED two AFTER my SO"
# Notes:

# The string "My after be arrived so two" has the property (P) but can't be obtained by the described process so it won't be accepted as a result. The property (P) doesn't give unicity by itself.
# Process: go from left to right, move only consecutive strings when needed.
# For the first fixed tests the needed number of moves to get property (P) is given as a comment so that you can know if your process follows the rule.

# MY SOLUTION:
defmodule Updown do
  require Integer

  def arrange(strng) do
    strng
    |> String.split(" ", trim: true)
    |> Enum.reduce({0, []}, &rearrangify(&1, &2))
    |> Kernel.elem(1)
    |> Enum.reduce({0, []}, &caseify(&1, &2))
    |> Kernel.elem(1)
    |> Enum.join(" ")
  end

  defp rearrangify(current_substring, {index, substring_list}) do
    substring_list = substring_list ++ [current_substring]
    previous_substring = Enum.at(substring_list, index - 1)

    substring_list = cond do
      index != 0 && Integer.is_even(index) && (String.length(previous_substring) < String.length(current_substring)) ->
        Enum.reverse_slice(substring_list, index - 1, 2)
      index != 0 && Integer.is_odd(index) && (String.length(previous_substring) > String.length(current_substring)) ->
        Enum.reverse_slice(substring_list, index - 1, 2)
      true ->
        substring_list
    end

    {index + 1, substring_list}
  end

  defp caseify(x, {index, list}), do: {index + 1, list ++ [(if Integer.is_even(index), do: String.downcase(x), else: String.upcase(x))]}
end


# A DIFFERENT SOLUTION:
defmodule Updown do
  def arrange(string) do
    string
    |> String.split(" ")
    |> arrange_list(false)
    |> Enum.zip(Stream.cycle([false, true]))
    |> Enum.map(fn {a, b} ->
      if b, do: String.upcase(a), else: String.downcase(a)
    end)
    |> Enum.join(" ")
  end

  defp arrange_list([_] = list, _), do: list
  defp arrange_list([fst | [snd | tail]], order) do
    {lfst, lsnd} = {String.length(fst), String.length(snd)}

    {a, b} = cond do
      (lfst <= lsnd && !order) || (lfst >= lsnd && order) ->
        {fst, snd}
      true ->
        {snd, fst}
    end

    [a | arrange_list([b | tail], !order)]
  end
end

# A CLEVER SOLUTION:
defmodule Updown do
  defp up([]) do [] end
  defp up([x]) do [String.downcase(x)] end
  defp up([x, y | xs]) do
    if String.length(x) <= String.length(y) do
      [String.downcase(x) | down([y | xs])]
    else
      [String.downcase(y) | down([x | xs])]
    end
  end
  defp down([]) do [] end
  defp down([x]) do [String.upcase(x)] end
  defp down([x, y | xs]) do
    if String.length(x) >= String.length(y) do
      [String.upcase(x) | up([y | xs])]
    else
      [String.upcase(y) | up([x | xs])]
    end
  end

  def arrange(strng) do
    s = String.split(strng, " ")
    Enum.join(up(s), " ")
  end
end
