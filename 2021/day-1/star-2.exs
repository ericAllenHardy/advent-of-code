depths =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

windows =
  List.zip([
    depths,
    Enum.drop(depths, 1),
    Enum.drop(depths, 2)
  ])
  |> Enum.map(fn {a, b, c} -> a + b + c end)

Enum.zip_with(
  windows,
  Enum.drop(windows, 1),
  &(&1 < &2)
)
|> Enum.filter(& &1)
|> length()
|> IO.puts()
