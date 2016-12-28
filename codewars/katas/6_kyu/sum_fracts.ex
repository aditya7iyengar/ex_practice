# You will have a list of rationals in the form

# m = [ [numer_1, denom_1] , ... , [numer_n, denom_n] ] or m = [ (numer_1, denom_1) , ... , (numer_n, denom_n) ]

# where all numbers are positive integers. You have to produce the sum N/D of these rationals in an irreducible form ie N and D have only 1 for divisor.

# The result will be written in the form

# [N, D] in Ruby/Python/Clojure/JS/CS/PHP
# Just "N D" in Haskell or Some "N D" in F#
# "[N, D]" in Java, CSharp, TS
# {N, D} in C++
# {N, D} in Elixir
# Example:

# [ [1, 2], [1, 3], [1, 4] ] ---->
# [13, 12] or: Just "13 12" (Haskell) or: "[13, 12]" (Java, CSharp, TS) or: {13, 12} (C++, Elixir)
# Notes:

# If m is [] return

# nil/None/null (Ruby/Elixir/Clojure/Python/JS/CS/TS/Java/CSharp/PHP)
# Nothing (Haskell) None (F#)
# {0, 1} (C++)
# If D divise N return:

# N/D as an integer: n (Ruby/Elixir/Clojure/Python/JS/CS/PHP)
# Just "n" (Haskell), Some "n" (Haskell), "n" (Java, CSharp, TS), {n, 1} (C++).

defmodule Sumfracts do
  def sum_fracts(list) when (list == nil) do nil end
  def sum_fracts(list) when (list == []) do nil end

  def sum_fracts(list) do
    lcm = list
      |> get_demon_list
      |> get_lcm

    lcm_list = list
      |> get_lcm_list(lcm)

    sum = lcm_list
      |> get_numer_list
      |> Enum.reduce(0, &(&1 + &2))

    gcd = get_gcd(sum, lcm)

    case div(lcm, gcd) do
      1 ->
        div(sum, gcd)
      _ ->
        {div(sum, gcd), div(lcm, gcd)}
    end
  end

  defp get_numer_list(list), do: Enum.map(list, fn ({numer, _}) -> numer end)

  defp get_demon_list(list), do: Enum.map(list, fn ({_, demon}) -> demon end)

  defp get_lcm(list), do: Enum.reduce(list, fn(numer, demon) -> div(abs(numer * demon), get_gcd(numer, demon)) end)

  defp get_lcm_list(list, lcm), do: Enum.map(list, fn ({numer, demon}) -> {div(numer * lcm, demon), lcm} end)

  defp get_gcd(numer, 0), do: abs(numer)

  defp get_gcd(numer, demon), do: get_gcd(demon, rem(numer, demon))
end
