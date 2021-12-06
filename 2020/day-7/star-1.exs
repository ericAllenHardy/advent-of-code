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
            [_, adjective, color, _] = String.split(s, " ")
            "#{adjective} #{color}"
          end)
      end

    bags_contained
    |> Enum.reduce(
      rules,
      &Map.update(&2, &1, MapSet.new([bag_name]), fn s -> MapSet.put(s, bag_name) end)
    )
  end

  def find_closure(rules, bag_name) do
    case Map.get(rules, bag_name) do
      nil ->
        MapSet.new()

      bag_names ->
        find_closure(
          rules,
          MapSet.new(),
          :queue.from_list(MapSet.to_list(bag_names))
        )
    end
  end

  defp find_closure(rules, closure, queue) do
    case :queue.out(queue) do
      {:empty, _} ->
        closure

      {{:value, bag_name}, queue} ->
        find_closure(
          rules,
          MapSet.put(closure, bag_name),
          if MapSet.member?(closure, bag_name) do
            queue
          else
            rules
            |> Map.get(bag_name, MapSet.new())
            |> Enum.reduce(queue, &:queue.in/2)
          end
        )
    end
  end
end

File.read!("input.txt")
|> String.split("\n")
|> Enum.reduce(%{}, &Bags.add_rule/2)
|> Bags.find_closure("shiny gold")
|> MapSet.size()
|> IO.inspect()

#  |> Enum.reduce()
