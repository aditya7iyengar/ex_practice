# Description:

# Task:

# Your task is to write a function which returns the sum of following series upto nth term(parameter).

# Series: 1 + 1/4 + 1/7 + 1/10 + 1/13 + 1/16 +...
# Rules:

# You need to round the answer upto 2 decimal places and return it as String.
# If the given value is 0 then it should return 0.00
# You will only be given Natural Numbers as arguments.
# Examples:

# SeriesSum(1) => 1 = "1"
# SeriesSum(2) => 1 + 1/4 = "1.25"
# SeriesSum(5) => 1 + 1/4 + 1/7 + 1/10 + 1/13 = "1.57"
# NOTE: In PHP the function is called series_sum().

# MY SOLUTION:
defmodule Series do
  def sum(0), do: "0.00"
  def sum(1), do: "1.00"

  def sum(n) do
    n
    |> generate_numbers
    |> add_numbers
    |> rounder
  end

  defp generate_numbers(n) do
    for num <- 0..n - 1 do
      1 / (1 + 3 * num)
    end
  end

  defp add_numbers(list) do
    Enum.reduce(list, 0, fn (x, acc) -> (x + acc)/1 end)
  end

  defp rounder(num) do
    Float.round(num, 2)
    |> Float.to_string([decimals: 2])
  end
end

# BEST SOLUTION:
defmodule Series do
  def sum(n) do
    # the docs don't mention options on to_string, but
    # i found some references that implied it.
    # also the instructions say "round up", but
    # the test suite fails if you do that.  :-P
    do_sum(n, 0.0) |> Float.to_string(decimals: 2)
  end
  defp do_sum(0, acc), do: acc
  defp do_sum(n, acc) do
    do_sum(n - 1, acc + 1.0 / (n * 3 - 2))
  end
end
