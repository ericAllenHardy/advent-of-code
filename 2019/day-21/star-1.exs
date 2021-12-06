parse_input = fn s ->
  s |> String.to_integer()
end

numbers =
  File.read!('input.txt')
  |> String.split(",")
  |> Enum.map(fn s -> s |> String.trim() |> String.to_integer() end)
  |> Enum.reject(fn n -> n >= 0 and n <= 127 end)
  # |> Enum.sum()
  |> IO.inspect()
