crab_posns =
  File.read!("./input.txt")
  |> String.split(",")
  |> Enum.frequencies()
  |> Enum.map(fn {x, n} -> {String.to_integer(x), n} end)

{min_x, max_x} =
  crab_posns
  |> Enum.map(&elem(&1, 0))
  |> Enum.min_max()

for destination <- min_x..max_x do
  {
    destination,
    Enum.map(crab_posns, fn {x, crabs} ->
      linear_cost = abs(destination - x)
      crabs * linear_cost * (linear_cost + 1) / 2
    end)
    |> Enum.sum()
  }
end
|> Enum.min_by(&elem(&1, 1))
|> IO.inspect()
