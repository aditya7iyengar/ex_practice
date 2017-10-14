defmodule Skyscraper do
  @moduledoc """
  This module handles operations related to a skyscraper
  """

  @doc """
  This struct represents a skyscrapers

  * heights: List of possible heights of a skyscraper.
  * x: x-coordinate of the skyscraper on the grid.
  * y: y-coordinate of the skyscraper on the grid.
  """
  @enforce_keys [:heights, :x, :y]
  defstruct [:heights, :x, :y]

  @doc """
  This function checks if a skyscraper is resolved, i.e. has only one
  possible height candidate
  """
  def resolved?(%Skyscraper{heights: heights}), do: length(heights) == 1
end

defmodule Strip do
  @moduledoc """
  This module handles operations related to a strip of skyscrapers
  """

  @doc """
  This struct represents a strip of skyscrapers

  * clue1: Clue at the beginning of a strip (top or left)
  * clue2: Clue at the end of a strip (bottom or right)
  * line: A tuple representing the direction and position of the strip:
        {horizontal (true or false), radius (distance from origin)}
  """
  @enforce_keys [:line]
  defstruct [:clue1, :clue2, :line]
end

defmodule Matrix do
  @moduledoc """
  This module handles operations related to a matrix/grid of skyscrapers
  """

  @doc """
  This struct represents a matrix/grid of skyscrapers

  * skyscrapers: List of skyscrapers structs to keep track of heights
  * max_height: Max Height of skyscrapers. It is also equal to size of the
                Matrix/Grid
  """
  @enforce_keys [:skyscrapers, :max_height]
  defstruct [:skyscrapers, :max_height]


  @doc """
  Creates a matrix/grid with skyscrapers having all possible heights
  """
  def setup(max_height) do
    skyscrapers = (0..max_height - 1)
      |> Enum.to_list()
      |> Enum.map(fn(y) ->
        (0..max_height - 1)
        |> Enum.to_list()
        |> Enum.map(&create_skyscraper(&1, y, max_height))
      end)
      |> Enum.flat_map(& &1)

    %Matrix{skyscrapers: skyscrapers, max_height: max_height}
  end

  @doc """
  Creates a skyscraper having all possible heights
  """
  def create_skyscraper(x, y, max_height) do
    %Skyscraper{heights: Enum.to_list(1..max_height), x: x, y: y}
  end

  @doc """
  This function checks if a matrix is resolved, i.e. if all the skyscrapers
  in the matrix are resolved.
  """
  def resolved?(%Matrix{skyscrapers: skyscrapers}) do
    Enum.all?(skyscrapers, &Skyscraper.resolved?(&1))
  end

  @doc """
  This function returns a two dimensional list representing the matrix's
  skyscrapers with their heights
  """
  def humanize(%Matrix{skyscrapers: skyscrapers, max_height: max_height}) do
    skyscrapers
    |> Enum.map(&Enum.at(&1.heights, 0))
    |> Enum.chunk(max_height)
  end

  @doc """
  This function returns a skyscraper in a matrix at a specified location
  """
  def get_skyscraper(%Matrix{skyscrapers: skyscrapers}, {x, y}) do
    Enum.find(skyscrapers, & &1.x == x && &1.y == y)
  end
end

defmodule Permutation do
  @moduledoc """
  This module gets permutations of a list.
  """

  @doc """
  This function takes a list as the argument and returns a list
  of its permutations
  """
  def get([]), do: [[]]
  def get(l), do: for h <- l, t <- get(l -- [h]), do: [h | t]
end

defmodule PuzzleSolver do
  @moduledoc """
  Coordinate Frame:
    (origin) x --->
      y
      |
      V
  """

  # This implementation is should work for any grid size
  @max_height 6

  @doc """
  This function takes in a set of clues (integers) and returns a matrix/grid
  satisfying those set of clues.
  """
  def solve(clues) do
    strips = clue_index_pairs()
      |> Enum.with_index()
      |> Enum.map(&gen_strip(&1, clues))

    Matrix.setup(@max_height)
    |> resolve_matrix(strips)
    |> Matrix.humanize()
  end

  # Generates a strip struct based on pair of clues and their indices
  defp gen_strip({clue_index, i}, clues) do
    line = i < @max_height && {false, i} || {true, i - @max_height}
    %Strip{
      clue1: Enum.at(clues, elem(clue_index, 0)),
      clue2: Enum.at(clues, elem(clue_index, 1)),
      line: line
    }
  end

  # Pairs of clue indices present on opposite sides of strips
  defp clue_index_pairs() do
    row_clues = 0..@max_height - 1
      |> Enum.map(&{&1, @max_height*3 - (&1 + 1)})
    col_clues =(@max_height*3..(@max_height*4 - 1))
      |> Enum.map(&{&1, @max_height*5 - (&1 + 1)})
      |> Enum.reverse

    row_clues ++ col_clues
  end

  # This loops until matrix struct is resolved
  defp resolve_matrix(matrix, strips) do
    case Matrix.resolved?(matrix) do
      true -> matrix
      false ->
        strips
        |> Enum.reduce(matrix, &attempt_resolution(&2, &1))
        |> resolve_matrix(strips)
    end
  end

  # This function calls apply_clue for both strip clues
  defp attempt_resolution(matrix, strip) do
    matrix
    |> apply_clue(strip, :clue1)
    |> apply_clue(strip, :clue2)
  end

  # This function applies a clue and changes height candidates of skyscrapers
  # and returns a new updated matrix
  defp apply_clue(matrix, strip, clue_type) when clue_type in [:clue1, :clue2] do
    skyscrapers = get_skyscrapers(matrix, strip.line)
    skyscrapers = case clue_type do
      :clue2 -> Enum.reverse(skyscrapers)
      :clue1 -> skyscrapers
    end

    valid_combos = case Map.get(strip, clue_type) do
      0 -> get_combos(skyscrapers)
      @max_height -> get_combos(:max_height)
      visibility ->
        skyscrapers
        |> get_combos()
        |> Enum.filter(& get_visibility(&1) == visibility)
    end

    update_matrix(matrix, skyscrapers, valid_combos)
  end

  # This function returns a new matrix with updated values of skyscrapers
  defp update_matrix(matrix, skyscrapers, valid_combos) do
    skyscrapers = update_skyscrapers(skyscrapers, valid_combos)

    s = 0..@max_height - 1
      |> Enum.to_list()
      |> Enum.map(fn(y) ->
        0..@max_height - 1
        |> Enum.to_list()
        |> Enum.map(fn(x) ->
          case Enum.find(skyscrapers, fn(s) -> s.x == x && s.y == y end) do
            nil -> Matrix.get_skyscraper(matrix, {x, y})
            skyscraper -> skyscraper
          end
        end)
      end)
      |> Enum.flat_map(& &1)

    %Matrix{skyscrapers: s, max_height: @max_height}
  end

  # This function returns new list of skyscrapers based on valid_combinations
  # of heights
  defp update_skyscrapers(skyscrapers, valid_combos) do
    valid_combos = valid_combos
      |> Enum.filter(fn(combo) ->
        combo
        |> Enum.with_index()
        |> Enum.all?(fn({h, i}) ->
          skyscrapers
          |> Enum.at(i)
          |> Map.get(:heights)
          |> Enum.member?(h)
        end)
      end)

    skyscrapers
    |> Enum.with_index()
    |> Enum.map(fn({s, i}) ->
      heights = s.heights -- (s.heights -- Enum.map(valid_combos, &Enum.at(&1, i)))
      %Skyscraper{x: s.x, y: s.y, heights: heights}
    end)
  end

  # This function computes visibility of a strip of skyscrapers
  defp get_visibility(heights) do
    heights
    |> Enum.reduce({0, 0}, fn(h, {v, hmax}) ->
        (h > hmax) && {v+1, h} || {v, hmax}
      end)
    |> elem(0)
  end

  # This function gets a valid list of combination of heights for a strip
  defp get_combos(:max_height), do: [Enum.to_list(1..@max_height)]
  defp get_combos(skyscrapers) do
    (1..@max_height)
    |> Enum.to_list()
    |> Permutation.get()
    |> Enum.filter(fn(combo) ->
      combo
      |> Enum.with_index()
      |> Enum.all?(fn({h, i}) ->
        skyscrapers
        |> Enum.at(i)
        |> Map.get(:heights)
        |> Enum.member?(h)
      end)
    end)
  end

  # This function gets a list of skyscrapers in a matrix, corresponding to
  # a line
  defp get_skyscrapers(%Matrix{skyscrapers: skyscrapers}, {false, rad}) do
    Enum.filter(skyscrapers, & &1.x == rad)
  end
  defp get_skyscrapers(%Matrix{skyscrapers: skyscrapers}, {true, rad}) do
    Enum.filter(skyscrapers, & &1.y == rad)
  end
end

# c "6_by_6_skyscrapers.ex"
# cluez = [0, 0, 1, 2, 0, 2, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0]
# IO.inspect PuzzleSolver.solve(cluez)
clues    = [0, 0, 1, 2,
            0, 2, 0, 0,
            0, 3, 0, 0,
            0, 1, 0, 0]
expected = [ [2, 1, 4, 3],
             [3, 4, 1, 2],
             [4, 2, 3, 1],
             [1, 3, 2, 4] ]

IO.inspect PuzzleSolver.solve(clues) == expected
#
# IO.inspect PuzzleSolver.solve(clues)
