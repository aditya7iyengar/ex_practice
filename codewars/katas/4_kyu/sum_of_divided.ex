# Given an array of positive or negative integers

# I= [i1,..,in]

# you have to produce a sorted array P of the form

# [ [p, sum of all ij of I for which p is a prime factor (p positive) of ij] ...]

# P will be sorted by increasing order of the prime numbers. The final result has to be given as a string in Java, C# or C++ and as an array of arrays in other languages.

# Example:

# I = [12, 15] # result = [{2, 12}, {3, 27}, {5, 15}]
# [2, 3, 5] is the list of all prime factors of the elements of I, hence the result.

# Notes: It can happen that a sum is 0 if some numbers are negative!

# Example: I = [15, 30, -45] 5 divides 15, 30 and (-45) so 5 appears in the result, the sum of the numbers for which 5 is a factor is 0 so we have [5, 0] in the result amongst others.

# MY FIRST ATTEMPT:
defmodule Sumofdivided do
  def sum_of_divided([]), do: []

  def sum_of_divided(lst) do
    lst
    |> Enum.sort
    |> get_relevant_primes
    |> prime_factorized_list(lst)
  end

  defp is_prime?(n), do: (2..n |> Enum.filter(&rem(n, &1) == 0) |> length) == 1

  defp get_relevant_primes(lst), do: Enum.filter(2..List.last(lst), &is_prime?(&1))

  defp prime_factorized_list(primes, lst) do
    Enum.reduce(primes, [], fn(x, acc) ->
      multiples = Enum.filter(lst, &rem(&1, x) == 0)
      case multiples do
        [] ->
          acc
        _ ->
          sum = Enum.reduce(multiples, 0, fn(x, s) ->
            s + x
          end)
          acc ++ [{x, sum}]
      end
    end)
  end

  # To get lesser number of primes
  # defp get_relevant_primes(lst) do
  #   largest_num = List.last(lst)

  #   max_prime = max(round(Float.ceil(1.0 * largest_num / 2)), (List.last(Enum.filter(lst, &is_prime?(&1))) || 0))

  #   Enum.filter(2..max_prime, &is_prime?(&1))
  # end
end


# MY FINAL SOLUTION:
defmodule Sumofdivided do
  def sum_of_divided(list) do
    list
    |> Enum.map(&break(abs(&1)))
    |> Enum.concat
    |> Enum.uniq
    |> Enum.sort
    |> Enum.map(&form_list(list, &1))
  end

  defp form_list(list, num), do: {num, list |> Enum.filter(&rem(&1, num) == 0) |> Enum.sum}
  defp break(n), do: _break(n, 2, [])
  defp _break(n, k, acc) when n < k*k, do: Enum.reverse(acc, [n])
  defp _break(n, k, acc) when rem(n, k) == 0, do: _break(div(n, k), k, [k | acc])
  defp _break(n, k, acc), do: _break(n, k+1, acc)
end
