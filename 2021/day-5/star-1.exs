defmodule Star do
  def parse_line(line) do
    [_, x1, y1, x2, y2] = Regex.run(~r/^([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)$/, line)

    {
      {String.to_integer(x1), String.to_integer(y1)},
      {String.to_integer(x2), String.to_integer(y2)}
    }
  end

  def horizontal_or_vertical?({{x1, y1}, {x2, y2}}) do
    x1 == x2 or y1 == y2
  end

  def count_points(lines) do
    count_points(lines, %{})
  end

  defp count_points([], counts), do: counts

  defp count_points([line | lines], counts) do
    new_counts =
      line
      |> points_for_line()
      |> Enum.reduce(counts, fn point, cs ->
        Map.update(cs, point, 1, &(&1 + 1))
      end)

    count_points(lines, new_counts)
  end

  defp points_for_line({{x1, y1}, {x2, y2}}) do
    for x <- x1..x2,
        y <- y1..y2 do
      {x, y}
    end
  end
end

lines =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(&Star.parse_line/1)
  |> Enum.filter(&Star.horizontal_or_vertical?/1)

Star.count_points(lines)
|> Enum.filter(fn {_, count} -> count >= 2 end)
|> length()
|> IO.puts()
