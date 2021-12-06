File.read!("input.txt")
|> String.split("\n\n")
|> Enum.map(fn group ->
  group
  |> String.split("\n")
  |> Enum.map(fn user ->
    user
    |> String.codepoints()
    |> MapSet.new()
  end)
  |> Enum.reduce(&MapSet.intersection/2)
  |> MapSet.size()
end)
|> Enum.sum()
|> IO.puts()
