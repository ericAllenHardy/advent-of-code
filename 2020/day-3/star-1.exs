defmodule SkiLine do
  def line([]), do: 0

  def line(terrain = [top | _], dx, dy) do
    line(terrain, dx, dy, String.length(top), 0, 0)
  end

  def line([], dx, dy, _width, _x, tree_count), do: tree_count

  def line(terrain = [top | _], dx, dy, width, x, tree_count) do
    new_count = if String.at(top, x) == "#", do: tree_count + 1, else: tree_count

    line(terrain |> Enum.drop(dy), dx, dy, width, rem(x + dx, width), new_count)
  end
end

terrain =
  File.read!("input.txt")
  |> String.split("\n")

[{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
|> Enum.map(fn {dx, dy} -> SkiLine.line(terrain, dx, dy) end)
|> Enum.reduce(&*/2)
|> IO.puts()
