# Description:

# You are given an array strarr of strings and an integer k. Your task is to return the first longest string consisting of k consecutive strings taken in the array.

# Example:

# longest_consec(["zone", "abigail", "theta", "form", "libe", "zas", "theta", "abigail"], 2) --> "abigailtheta"

# n being the length of the string array, if n = 0 or k > n or k <= 0 return "".

# MY SOLUTION:
defmodule Longestconsec do
  def longest_consec([], _), do: ""
  def longest_consec(strarr, k) when (k <= 0) or (k > length(strarr)), do: ""

  def longest_consec(strarr, k) do
    Enum.reduce(strarr, {"", 0}, &get_current_consec(&1, strarr, &2, k))
    |> elem(0)
  end

  defp get_current_consec(_str, strarr, {current_consec, index}, k) do
    candidate = candidate(strarr, index, k)
    if String.length(current_consec) < String.length(candidate), do: {candidate, index + 1}, else: {current_consec, index + 1}
  end

  defp candidate(strarr, index, k) do
    strarr
    |> Enum.slice(index..(index + k - 1))
    |> Enum.join
  end
end

# BEST SOLUTION:
defmodule Longestconsec do
  def longest_consec([], _), do: ""
  def longest_consec(strarr, k) when length(strarr) < k or k <= 0, do: ""

  def longest_consec(strarr, k) do
    Enum.chunk(strarr, k, 1)
    |> Enum.map(&Enum.join/1)
    |> Enum.max_by(&String.length/1)
  end
end
