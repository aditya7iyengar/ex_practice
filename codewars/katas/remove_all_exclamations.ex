# Description:

# Remove all exclamation marks from sentence except at the end.

# Examples

# remove("Hi!") == "Hi!"
# remove("Hi!!!") == "Hi!!!"
# remove("!Hi") == "Hi"
# remove("!Hi!") == "Hi!"
# remove("Hi! Hi!") == "Hi Hi!"
# remove("Hi") == "Hi"

# MY SOLUTION:
defmodule Solution do
  def remove(s) do
    String.replace(s, ~r/!(?!!*$)/, "")
  end
end
