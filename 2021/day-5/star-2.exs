defmodule Star do
  def parse_line(line) do
    [_, x1, y1, x2, y2] = Regex.run(~r/^([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)$/, line)

    {
      {String.to_integer(x1), String.to_integer(y1)},
      {String.to_integer(x2), String.to_integer(y2)}
    }
  end

  def points_for_line({{x1, y1}, {x2, y2}}) do
    cond do
      x1 == x2 -> for y <- y1..y2, do: {x1, y}
      y1 == y2 -> for x <- x1..x2, do: {x, y1}
      true -> Enum.zip(x1..x2, y1..y2)
    end
  end
end

File.read!("./input.txt")
|> String.split("\n")
|> Enum.flat_map(&(&1 |> Star.parse_line() |> Star.points_for_line()))
|> Enum.frequencies()
|> Enum.count(fn {_, count} -> count >= 2 end)
|> IO.inspect(label: "one")
