input =
  File.read!("input.txt")
  |> IntCode.parse()

indices = Range.new(0, length(input) - 1)

for a <- indices, b <- indices do
  input
  |> List.update_at(1, fn _ -> a end)
  |> List.update_at(2, fn _ -> b end)
  |> IntCode.run()
  |> Enum.at(0)
  |> case do
    19_690_720 -> (100 * a + b) |> Integer.to_string() |> IO.puts()
    _ -> nil
  end
end
