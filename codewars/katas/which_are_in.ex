# Given two arrays of strings a1 and a2 return a sorted array r in lexicographical order of the strings of a1 which are substrings of strings of a2.

# Example 1:

# a1 = ["arp", "live", "strong"]

# a2 = ["lively", "alive", "harp", "sharp", "armstrong"]

# returns ["arp", "live", "strong"]

# Example 2:

# a1 = ["tarp", "mice", "bull"]

# a2 = ["lively", "alive", "harp", "sharp", "armstrong"]

# returns []

# Notes:

# Arrays are written in "general" notation. See "Your Test Cases" for examples in your language.

# Beware: r must be without duplicates.

# MY INITIAL SOLUTION:
defmodule Whicharein do
  def in_array(array1, array2) do
    array1
    |> get_strings_which_are_in(array2)
    |> Enum.uniq
    |> Enum.filter(& &1)
    |> Enum.sort
  end

  defp get_strings_which_are_in(array1, array2) do
    for substring <- array1, string <- array2 do
      if String.contains?(string, substring) do
        substring
      end
    end
  end
end

# MY FINAL SOLUTION:
defmodule Whicharein do
  def in_array(array1, array2) do
    array1
    |> Enum.filter(&substring?(&1, array2))
    |> Enum.sort
  end

  defp substring?(substring, array2) do
    Enum.any?(array2, fn(string) ->
      String.contains?(string, substring)
    end)
  end
end
