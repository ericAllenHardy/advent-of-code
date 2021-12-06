defmodule Star do
  def parse_line(s) do
    [instruction, n] = String.split(s)
    {instruction, String.to_integer(n)}
  end

  def move({"forward", n}, {depth, distance, aim}), do: {depth + n * aim, distance + n, aim}
  def move({"up", n}, {depth, distance, aim}), do: {depth, distance, aim - n}
  def move({"down", n}, {depth, distance, aim}), do: {depth, distance, aim + n}
end

{depth, distance, _} =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(&Star.parse_line/1)
  |> Enum.reduce({0, 0, 0}, &Star.move/2)

IO.puts(depth * distance)
