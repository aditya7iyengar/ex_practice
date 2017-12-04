defmodule Tosmallest do
  def smallest(number) do
    number
    |> to_string()
    |> String.codepoints()
    |> get_smallest()
  end

  defp get_smallest(list) do
    list
    |> make_oneop_combos()
    |> Enum.min()
  end

  defp make_oneop_combos(list) do
    list
    |> Enum.with_index()
    |> Enum.map(&filter_combos_on_index(list, &1))
  end

  defp filter_combos_on_index(list, {digit, i}) do
    sublist = List.delete_at(list, i)

    0..length(sublist)
    |> Enum.map(&right_shift(sublist, digit, i, &1))
    |> Enum.min()
  end

  defp right_shift(list, digit, i, j) do
    list
    |> List.insert_at(j, digit)
    |> Enum.join()
    |> String.to_integer()
    |> (&[&1, i, j]).()
  end
end
