# Description:

# Write a function partlist that gives all the ways to divide a list (an array) of at least two elements into two non-empty parts.

# Each two non empty parts will be in a pair (or an array for languages without tuples or a structin C - C: see Examples test Cases - )
# Each part will be in a string
# Elements of a pair must be in the same order as in the original array.
# Example:

# a = ["az", "toto", "picaro", "zone", "kiwi"] -->

# [["az", "toto picaro zone kiwi"], ["az toto", "picaro zone kiwi"], ["az toto picaro", "zone kiwi"], ["az toto picaro zone", "kiwi"]]

# or

# a = {"az", "toto", "picaro", "zone", "kiwi"} -->

# {{"az", "toto picaro zone kiwi"}, {"az toto", "picaro zone kiwi"}, {"az toto picaro", "zone kiwi"}, {"az toto picaro zone", "kiwi"}}

# or

# a = ["az", "toto", "picaro", "zone", "kiwi"] -->

# [("az", "toto picaro zone kiwi"), ("az toto", "picaro zone kiwi"), ("az toto picaro", "zone kiwi"), ("az toto picaro zone", "kiwi")]

# or

# a = [|"az", "toto", "picaro", "zone", "kiwi"|] -->

# [("az", "toto picaro zone kiwi"), ("az toto", "picaro zone kiwi"), ("az toto picaro", "zone kiwi"), ("az toto picaro zone", "kiwi")]

# You can see other examples for each language in "Your test cases"


# BEST SOLUTION:
defmodule Partlist do
  def part_list(a)do
    Enum.map(1..(length(a) - 1), fn num ->
      Enum.split(a, num)
      |> Tuple.to_list
      |> Enum.map(&Enum.join(&1, " "))
    end)
  end
end


# MY SOLUTION:
defmodule Partlist do
  def part_list(a) do
    for n <- 1..(Enum.count(a) - 1) do
      {head, tail} = Enum.split(a, n)
      [Enum.join(head, " "), Enum.join(tail, " ")]
    end
  end
end