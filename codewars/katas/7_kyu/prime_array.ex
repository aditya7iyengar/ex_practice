defmodule PrimeArray do
  def get_primes(n) when n < 2, do: []
  def get_primes(n), do: Enum.filter(2..n, &is_prime?(&1))

  defp is_prime?(n) when n in [2, 3], do: true
  defp is_prime?(n) do
    floored_sqrt = n
      |> :math.sqrt
      |> Float.floor
      |> round
    !Enum.any?(2..floored_sqrt, &(rem(n, &1) == 0))
  end
end
