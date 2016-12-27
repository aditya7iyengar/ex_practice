# My Elixir Notes/Tricks

## Strings

### To list:
```
String.split("abc", "", trim: true) # This is preferred.

String.codepoints("abc") # This is faster, but is not good with some edge cases.
```

### RegEx in functions:

```
String.replace(s, ~r/!(?!!*$)/, "") # This removes exclamations except the last one
```

## Lists

### Rotation:

```
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


