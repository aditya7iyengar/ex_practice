# Given an n x n array, return the array elements arranged from outermost elements to the middle element, traveling clockwise.
#
# array = [[1,2,3],
#          [4,5,6],
#                   [7,8,9]]
#                   snail(array) #=> [1,2,3,6,9,8,7,4,5]
#                   For better understanding, please follow the numbers of the next array consecutively:
#
#                   array = [[1,2,3],
#                            [8,9,4],
#                                     [7,6,5]]
#                                     snail(array) #=> [1,2,3,4,5,6,7,8,9]

# MY SOLUTION:
defmodule Snail do
  def snail(matrix) when matrix == [] or length(length(matrix)) == 1, do: matrix

  def snail([first_row | other]) do
    {second_row, other} = Enum.reduce(other, {[], []}, &rev_head_tail(&1, &2))
    Enum.concat([first_row, Enum.reverse(second_row), snail(other)])
  end

  defp rev_head_tail(line, {heads, tails}) do
    [head | tail] = Enum.reverse(line)
    {[head | heads], [tail | tails]}
  end
end
