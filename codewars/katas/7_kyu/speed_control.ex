# In John's car the GPS records every s seconds the distance travelled from an origin (distances are measured in an arbitrary but consistent unit). For example, below is part of a record with s = 15:

# x = [0.0, 0.19, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25]
# The sections are:

# 0.0-0.19, 0.19-0.5, 0.5-0.75, 0.75-1.0, 1.0-1.25, 1.25-1.50, 1.5-1.75, 1.75-2.0, 2.0-2.25
# We can calculate John's average hourly speed on every section and we get:

# [45.6, 74.4, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0, 60.0]
# Given s and x the task is to return as an integer the floor of the maximum average speed per hour obtained on the sections of x. If x length is less than or equal to 1 return 0 since the car didn't move.

# Example:

# with the above data your function gps(x, s)should return 74

# MY FIRST ATTEMPT: (Don't know what's wrong with it, but a test was failing..)
defmodule Speedcontrol do
  def gps(_s, []), do: 0

  def gps(s, x) do
    x
    |> get_sections
    |> get_average_speeds(s)
    |> Enum.max
    |> Float.floor
  end

  defp get_sections([_]), do: nil

  defp get_sections([first | [second | _] = tail]) do
    case get_sections(tail) do
      nil ->
        [{first, second}]
      list_of_tuples ->
        [{first, second}] ++ list_of_tuples
    end
  end

  defp get_average_speeds(sections_list, interval) do
    Enum.map(sections_list, fn({start, finish}) ->
      (finish - start) / interval * 3600
    end)
  end
end

# MY FINAL SOLUTION:
defmodule Speedcontrol do
  def gps(_s, []), do: 0

  def gps(s, x) do
      x
      |> Enum.map_reduce(0, fn (coordinate, acc) ->
        {get_average_speed(coordinate - acc, s), coordinate}
      end)
      |> elem(0)
      |> Enum.max
      |> Float.floor
  end

  defp get_average_speed(section, interval) do
    section / interval * 3600
  end
end
