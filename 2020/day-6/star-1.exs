File.read!("input.txt")
|> String.split("\n\n")
|> Enum.map(fn group ->
  group
  |> String.replace("\n", "")
  |> String.codepoints()
  |> MapSet.new()
  |> MapSet.size()
end)
|> Enum.sum()
|> IO.puts()
