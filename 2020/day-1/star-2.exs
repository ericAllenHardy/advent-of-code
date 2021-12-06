numbers =
  File.read!('input.txt')
  |> String.split("\n")
  |> Enum.map(fn s -> s |> String.trim() |> String.to_integer() end)
  |> MapSet.new()

for a <- numbers, b <- numbers, MapSet.member?(numbers, 2020 - a - b) do
  (a * b * (2020 - a - b))
  |> Integer.to_string()
  |> IO.puts()
end
