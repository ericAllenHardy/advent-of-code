numbers =
  File.read!('input.txt')
  |> String.split("\n")
  |> Enum.map(fn s -> s |> String.trim() |> String.to_integer() end)
  |> MapSet.new()

Enum.find(numbers, nil, fn n -> MapSet.member?(numbers, 2020 - n) end)
|> case do
  nil -> IO.puts("something went wrong")
  n -> (n * (2020 - n)) |> Integer.to_string() |> IO.puts()
end
