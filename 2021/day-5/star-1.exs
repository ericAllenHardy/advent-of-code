defmodule Star do
  def parse_line(line) do
    [_, x1, y1, x2, y2] = Regex.run(~r/^([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)$/, line)

    {
      {String.to_integer(x1), String.to_integer(y1)},
      {String.to_integer(x2), String.to_integer(y2)}
    }
  end

  def horizontal_or_vertical?({{x1, y1}, {x2, y2}}), do: x1 == x2 or y1 == y2

  def points_for_line({{x1, y1}, {x2, y2}}) do
    for x <- x1..x2,
        y <- y1..y2 do
      {x, y}
    end
  end
end

File.read!("./input.txt")
|> String.split("\n")
|> Enum.map(&Star.parse_line/1)
|> Enum.flat_map(fn coords ->
  if Star.horizontal_or_vertical?(coords) do
    Star.points_for_line(coords)
  else
    []
  end
end)
|> Enum.frequencies()
|> Enum.count(fn {_, count} -> count >= 2 end)
|> IO.puts()
