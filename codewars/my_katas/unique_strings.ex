# Given a string, string, you have to find out the number of unique strings 
# (including string itself) that can be produced by re-arranging the letters 
# of the string.
# Example:
#
# string = "ABC"
#
# uniqcount(string) = 6 #=> ["ABC", "ACB", "BAC", "BCA", "CAB", "CBA"]
#
# Notes: Find the number of UNIQUE strings!
#
# Examples:
#
# uniqcount("AB") = 2
#
# uniqcount("ABC") = 6
#
# uniqcount("ABA") = 3
#
# uniqcount("ABCD") = 24
#
# uniqcount("ABBB") = 4

defmodule UniqueStrings do
  
  def uniq_count(string) do
   String.downcase(string)
    |> String.codepoints
    |> Enum.reduce(%{}, &char_repeats(&1, &2))
    |> Enum.reduce(factorial(String.length(string)), &get_num_uniq(&1, &2))
  end
  
  defp char_repeats(letter, letters) do
    l = String.to_atom(letter)
    case letters[l] do
      nil -> Map.put(letters, l, 1)
      num -> Map.put(letters, l, num + 1)
    end
  end
  
  defp get_num_uniq({_char, num}, fun), do: if num == 1, do: fun, else: div(fun, factorial(num))
  
  defp factorial(n) when n == 0 or n == 1, do: 1
  
  defp factorial(n) when n > 0, do: n * factorial(n - 1)
end

# THE SOLUTION THAT WON'T WORK:
defmodule UniqueStrings do
  def uniq_count(string) do
    permute(string) |> Enum.uniq |> length
  end
  
  def permute(input) do
    cond do
      String.length(input) < 2 -> 
        [input]
      true ->
        Enum.reduce(0..String.length(input), [], fn(x, perms) ->
          char = String.at(input, x)
          rest = String.slice(input, 0..x) <> String.slice(input, (x + 1)..-1)
          perms ++ Enum.map(permute(rest), fn(substring) -> 
            char <> substring 
          end)
        end)
    end
  end
end

