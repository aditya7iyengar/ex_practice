# Take an integer n (n >= 0) and a digit d (0 <= d <= 9) as an integer. Square all numbers k (0 <= k <= n) between 0 and n. Count the numbers of digits d used in the writing of all the k**2. Call nb_dig (or nbDig or ...) the function taking n and d as parameters and returning this count.

# Examples:

# n = 10, d = 1, the k*k are 0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100
# We are using the digit 1 in 1, 16, 81, 100. The total count is then 4.

# nb_dig(25, 1):
# the numbers of interest are
# 1, 4, 9, 10, 11, 12, 13, 14, 19, 21 which squared are 1, 16, 81, 100, 121, 144, 169, 196, 361, 441
# so there are 11 digits `1` for the squares of numbers between 0 and 25.

# MY SOLUTION:
defmodule Countdigit do
  def nb_dig(n, d), do: n |> get_squares |> get_digit_count(d)

  defp get_squares(n), do: for num <- 0..n, do: num * num

  defp get_digit_count(n, d), do: Enum.reduce(n, 0, fn(x, acc) -> acc + num_of_occurances(x, d) end)

  defp num_of_occurances(x, d) do
    String.split(Integer.to_string(x), "", trim: true)
      |> Enum.count(fn(y) -> y == Integer.to_string(d) end)
  end
end


# BEST SOLUTION:
defmodule Countdigit do
  def nb_dig(n, d) do
    0 .. n
      |> Stream.flat_map(&(Integer.digits(&1 * &1)))
      |> Enum.count(&(&1 == d))
  end
end
