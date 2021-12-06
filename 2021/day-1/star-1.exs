depths =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

Enum.zip(depths, depths |> Enum.drop(1))
|> Enum.count(fn {a, b} -> a < b end)
|> IO.puts()
