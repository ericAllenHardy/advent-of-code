defmodule Bags do
  def add_rule(s, rules) do
    [bag_name, contains] = s |> String.trim(".") |> String.split(" bags contain ")

    bags_contained =
      case contains do
        "no other bags" ->
          []

        some_bags ->
          some_bags
          |> String.split(", ")
          |> Enum.map(fn s ->
            [count, adjective, color, _] = String.split(s, " ")
            {String.to_integer(count), "#{adjective} #{color}"}
          end)
      end

    Map.put(rules, bag_name, bags_contained)
  end

  def calc_bag_count(rules, bag_name) do
    {_, total} = calc_bag_count(rules, bag_name, %{})
    total
  end

  def calc_bag_count(rules, bag_name, counts) do
    case Map.get(counts, bag_name) do
      count when is_integer(count) ->
        {counts, count}

      _ ->
        inner_bags = Map.get(rules, bag_name)

        {counts, total} =
          Enum.reduce(
            inner_bags,
            {counts, 0},
            fn {n, inner_bag}, {counts, total} ->
              {counts, bag_count} = calc_bag_count(rules, inner_bag, counts)
              {counts, total + n + n * bag_count}
            end
          )

        {Map.put(counts, bag_name, total), total}
    end
  end
end

File.read!("input.txt")
|> String.split("\n")
|> Enum.reduce(%{}, &Bags.add_rule/2)
|> Bags.calc_bag_count("shiny gold")
|> IO.inspect()

#  |> Enum.reduce()
