# A traveling salesman has to visit clients. He got each client's address e.g. "432 Main Long Road St. Louisville OH 43071" as a list.

# The basic zipcode format usually consists of two capital letters followed by a white space and five digits. The list of clients to visit was given as a string of all addresses, each separated from the others by a comma, e.g. :

# "123 Main Street St. Louisville OH 43071,432 Main Long Road St. Louisville OH 43071,786 High Street Pollocksville NY 56432".

# To ease his travel he wants to group the list by zipcode.

# Task

# The function travel will take two parameters r (list of all clients' addresses) and zipcode and returns a string in the following format:

# zipcode:street and town,street and town,.../house number,house number,...

# The street numbers must be in the same order as the streets where they belong.

# If a given zipcode doesn't exist in the list of clients' addresses return "zipcode:/"

# Examples

# r = "123 Main Street St. Louisville OH 43071,432 Main Long Road St. Louisville OH 43071,786 High Street Pollocksville NY 56432"

# travel(r, "OH 43071") --> "OH 43071:Main Street St. Louisville,Main Long Road St. Louisville/123,432"

# travel(r, "NY 56432") --> "NY 56432:High Street Pollocksville/786"

# travel(r, "NY 5643") --> "NY 5643:/"
# Note: You can see the list of all addresses and zipcodes in the test cases.

# MY FIRST SOLUTION:
defmodule SalesmanTravel do
  def travel(r, zipcode) do
    r
    |> get_relevant_addresses(zipcode)
    |> format_addresses(zipcode)
  end

  defp get_relevant_addresses(r, zipcode) do
    String.split(r, ",", trim: true)
    |> Enum.filter(&String.slice(&1, -8, 8) == zipcode)
  end

  defp format_addresses(list, zipcode) do
    [units, streets] = Enum.reduce(list, [[], []], fn(address, [units, streets]) ->
        [unit, street] = String.slice(address, 0, String.length(address) - 9)
          |> String.split(" ", parts: 2)
        [units ++ [unit], streets ++ [street]]
      end)

    "#{zipcode}:#{Enum.join(streets, ",")}/#{Enum.join(units, ",")}"
  end
end

# MY FINAL SOLUTION:
defmodule SalesmanTravel do
  def travel([], zipcode), do: "#{zipcode}:/"
  def travel(r, zipcode), do: r |> format_addresses(zipcode)

  defp format_addresses(r, zipcode) do
    str = String.split(r, ",", trim: true)
      |> Enum.reduce([[], []], &format_address(&1, &2, zipcode))
      |> Enum.map(&Enum.join(&1, ","))
      |> Enum.join("/")

    "#{zipcode}:#{str}"
  end

  defp format_address(address, [streets, units], zipcode) do
    case String.slice(address, -8, 8) == zipcode do
      true ->
        [unit, street] = String.slice(address, 0, String.length(address) - 9)
          |> String.split(" ", parts: 2)
        [streets ++ [street], units ++ [unit]]
      false ->
        [streets, units]
    end
  end
end

defmodule SalesmanTravelTest do
  def run do
    SalesmanTravel.travel(addresses, "AA 45522") == "AA 45522:Paris St. Abbeville,Paris St. Abbeville/67,670"
  end

  def addresses do
    "123 Main Street St. Louisville OH 43071,432 Main Long Road St. Louisville OH 43071,786 High Street Pollocksville NY 56432,"<>
    "54 Holy Grail Street Niagara Town ZP 32908,3200 Main Rd. Bern AE 56210,1 Gordon St. Atlanta RE 13000,"<>
    "10 Pussy Cat Rd. Chicago EX 34342,10 Gordon St. Atlanta RE 13000,58 Gordon Road Atlanta RE 13000,"<>
    "22 Tokyo Av. Tedmondville SW 43098,674 Paris bd. Abbeville AA 45521,10 Surta Alley Goodtown GG 30654,"<>
    "45 Holy Grail Al. Niagara Town ZP 32908,320 Main Al. Bern AE 56210,14 Gordon Park Atlanta RE 13000,"<>
    "100 Pussy Cat Rd. Chicago EX 34342,2 Gordon St. Atlanta RE 13000,5 Gordon Road Atlanta RE 13000,"<>
    "2200 Tokyo Av. Tedmondville SW 43098,67 Paris St. Abbeville AA 45521,11 Surta Avenue Goodtown GG 30654,"<>
    "45 Holy Grail Al. Niagara Town ZP 32918,320 Main Al. Bern AE 56215,14 Gordon Park Atlanta RE 13200,"<>
    "100 Pussy Cat Rd. Chicago EX 34345,2 Gordon St. Atlanta RE 13222,5 Gordon Road Atlanta RE 13001,"<>
    "2200 Tokyo Av. Tedmondville SW 43198,67 Paris St. Abbeville AA 45522,11 Surta Avenue Goodville GG 30655,"<>
    "2222 Tokyo Av. Tedmondville SW 43198,670 Paris St. Abbeville AA 45522,114 Surta Avenue Goodville GG 30655,"<>
    "2 Holy Grail Street Niagara Town ZP 32908,3 Main Rd. Bern AE 56210,77 Gordon St. Atlanta RE 13000"
  end
end
