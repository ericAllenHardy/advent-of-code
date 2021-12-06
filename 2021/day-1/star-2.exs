depths =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

windowed_sums =
  List.zip_with([
    depths,
    depths |> Enum.drop(1),
    depths |> Enum.drop(2)
  ], &Enum.sum/1)

Enum.zip(
  windowed_sum,
  windowed_sum |> Enum.drop(1),
)
|> Enum.count(fn {a, b} -> a < b end)
|> IO.puts()
