defmodule Closest do
  @moduledoc """
  This module handles fetching two numbers in a string whose weights
  are the closest, smallest and smallest indicies
  """

  @doc """
  The public API to interact with this module. This function returns
  a list of two tuples each corresponding to a weight, index and number.
  These two numbers have the closest weights, smallest weights and smallest
  indices in the given string of numbers.
  """
  @spec closest(String.t) :: list(tuple())
  def closest(""), do: [{}, {}]
  def closest(str) do
    str
    |> get_sorted_weight_tuples()
    |> Enum.chunk(2, 1)
    |> Enum.min_by(&minfn/1)
  end

  # Gets a sorted list of tuples in format {weight, index, number}
  defp get_sorted_weight_tuples(str) do
    str
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn({num, i}) -> {get_weight(num), i, num} end)
    |> Enum.sort()
  end

  # This defines a rule to get minimum of a list of list of tuples
  defp minfn([{w1, _i1, _num1}, {w2, _i2, _num2}]), do: w2 - w1

  # Gets the weight of a string of digits
  defp get_weight(digits), do: digits |> Integer.digits() |> Enum.sum()
end
