defmodule Paths do
  def count_paths(paths), do: count_paths(Map.put(%{}, List.last(paths), 1), Enum.reverse(paths))

  def count_paths(paths_from_map, []), do: Map.get(paths_from_map, 0)

  def count_paths(paths_from_map, [item | path_items]) do
    path_count =
      Map.keys(paths_from_map)
      |> Enum.filter(&(&1 - item <= 3))
      |> Enum.map(&Map.get(paths_from_map, &1))
      |> Enum.sum()
      |> IO.inspect(label: "path count for #{item}")

    count_paths(Map.put(paths_from_map, item, path_count), path_items)
  end
end

voltages =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()
  |> IO.inspect(limit: :infinity)

[0 | voltages]
|> Paths.count_paths()
|> IO.inspect()
