defmodule NPrimes do
  def get_primes(n) when n < 2, do: []
  def get_primes(n), do: Enum.filter(2..n, &is_prime?(&1))

  def is_prime?(n) when n in [2, 3], do: true
  def is_prime?(x) do
    start_lim = div(x, 2)
    Enum.reduce(2..start_lim, {true, start_lim}, fn(fac, {is_prime, upper_limit}) ->
      cond do
        !is_prime -> {false, fac}
        fac > upper_limit -> {is_prime, upper_limit}
        true ->
          is_prime = rem(x, fac) != 0
          upper_limit = if is_prime, do: div(x, fac + 1), else: fac
          {is_prime , upper_limit}
      end
    end) |> elem(0)
  end
end

defmodule NPrimesStream do
  def get_primes(n) when n < 2, do: []
  def get_primes(n), do: Enum.filter(2..n, &is_prime?(&1))

  def is_prime?(n) when n in [2, 3], do: true
  def is_prime?(x) do
    start_lim = div(x, 2)
    fac_lim = Stream.unfold({2, start_lim}, fn({fac, upper_lim}) ->
      cond do
        fac > upper_lim -> nil
        true ->
          if rem(x, fac) == 0, do: nil, else: {{fac, upper_lim}, {fac + 1, div(x, fac + 1)}}
      end
    end) |> Enum.to_list |> List.last

    !is_nil(fac_lim) && elem(fac_lim, 0) <= elem(fac_lim, 1)
  end
end

defmodule FirstNPrimes do
  def get_first_n_primes(n) when n < 1, do: []
  def get_first_n_primes(n), do: Enum.filter(2..n, &is_prime?(&1))

  def is_prime?(n) when n in [2, 3], do: true
  def is_prime?(x) do
    start_lim = div(x, 2)
    Enum.reduce(2..start_lim, {true, start_lim}, fn(fac, {is_prime, upper_limit}) ->
      cond do
        !is_prime -> {false, fac}
        fac > upper_limit -> {is_prime, upper_limit}
        true ->
          is_prime = rem(x, fac) != 0
          upper_limit = if is_prime, do: div(x, fac + 1), else: fac
          {is_prime , upper_limit}
      end
    end) |> elem(0)
  end
end
