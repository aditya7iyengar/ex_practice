# Description:

# Input:

# a sting strng
# an array of strings arr
# Output of function contain_all_rots(strng, arr) (or containAllRots or contain-all-rots):

# a boolean true if all rotations of strng are included in arr (C returns 1)
# false otherwise (C returns 0)
# Examples:

# contain_all_rots(
#   "bsjq", ["bsjq", "qbsj", "sjqb", "twZNsslC", "jqbs"]) -> true

# contain_all_rots(
#   "Ajylvpy", ["Ajylvpy", "ylvpyAj", "jylvpyA", "lvpyAjy", "pyAjylv", "vpyAjyl", "ipywee"]) -> false)
# Note:

# Though not correct in a mathematical sense

# we will consider that there are no rotations of strng == ""
# and for any array arr: contain_all_rots("", arr) --> true
# Ref: https://en.wikipedia.org/wiki/String_(computer_science)#Rotations

# BEST SOLUTION:
defmodule AllInclusive do

  def contain_all_rots("", _), do: true
  def contain_all_rots(string, list) do
    strings = MapSet.new(list)
    0 .. String.length(string) - 1
      |> Stream.map(fn i -> {s1, s2} = String.split_at(string, i); s2 <> s1 end)
      |> Enum.all?(&(MapSet.member?(strings, &1)))
  end
end


# MY SOLUTION:
defmodule Allinclusive do

  def contain_all_rots("", _arr), do: true
  def contain_all_rots(strng, arr) do
    strng_as_list = String.split(strng, "", trim: true)

    rots = for n <- 0..String.length(strng) - 1, do: rot(strng_as_list, n)

    rots
    |> Enum.map(fn(x) -> Enum.join(x) end)
    |> Enum.all?(&Enum.member?(arr, &1))
  end

  def rot(arr, 0), do: arr
  def rot([head | arr], number) do
    rot(arr ++ [head], number - 1)
  end
end
