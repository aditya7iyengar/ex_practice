defmodule LargestInSeries do
  @moduledoc """
  This module is responsible for getting the largest n-digit sequence in a
  given string of integers
  """

  # This solution should work for any length of sequence
  @sequence_length 5

  @doc """
  Public API for this module: This function gets the largest n-digit sequence
  in a given string of integers
  """
  @spec solution(String.t) :: integer
  def solution(digits) do
    digits
    |> get_sequences()
    |> Enum.map(&String.to_integer(&1))
    |> Enum.max
  end

  # This function gets a list of sequences in a given string
  defp get_sequences(digits, len \\ @sequence_length) do
    str_length = String.length(digits)
    Enum.map((0..str_length - len), &sequence(digits, &1, len))
  end

  # This function slices a given string at the give index based on sequence length, len
  defp sequence(str, index, len), do: String.slice(str, index..index + len - 1)
end
