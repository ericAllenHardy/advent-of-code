depths =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

Enum.zip_with(
  depths,
  Enum.drop(depths, 1),
  fn a, b -> if a < b, do: 1, else: 0 end
)
|> Enum.sum()
|> IO.puts()
