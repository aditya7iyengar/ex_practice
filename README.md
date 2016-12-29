# My Elixir Notes/Tricks

## Enums

### Enum.reduce
- enumerable: simply the list
- accumulator: the value returned from first function is used as the accumulator for the next item of the enumerable (stores the state of previous iteration)
- function: that is applied to every item in the enumerable

The real fun in using Enum.reduce starts when you move beyond simply dealing with numbers as the accumulator. The accumulator can be any kind of value.
For example Enum.map can be implemented as:

```.ex
def map(list, fun) do
  Enum.reduce(list, [], fn(item, acc) ->
    [fun.(item) | acc]
  end)
  |> Enum.reverse
end
```

- Usage: Something can be converted to enumerable to do iterations (for example, string)
- Examples:
  - codewars/katas/speed_control.ex

## Strings

### To list:
```.ex
String.split("abc", "", trim: true) # This is preferred.

String.codepoints("abc") # This is faster, but is not good with some edge cases.
```

### RegEx in functions:

```.ex
String.replace(s, ~r/!(?!!*$)/, "") # This removes exclamations except the last one
```

### Get all chars in a string

```.ex
String.graphemes("abca") # ['a', 'b', 'c', 'a']
```

## Lists

### Rotation:

```.ex
def lrotate(list, 0), do: list
def lrotate([head | list], number), do: lrotate(list ++ [head], number - 1)
def rrotate(list, number) do
  list
  |> Enum.reverse
  |> lrotate(number)
  |> Enum.reverse
end

```

## Recursion and Loops Tricks:

- Define base case as a base_function
- Convert things into lists and then use it's modifiers.
- Examples:
  - codewars/katas/max_rot.ex,
  - codewars/katas/all_inclusive.ex


