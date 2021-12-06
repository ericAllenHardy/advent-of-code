voltages =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()
  |> IO.inspect(limit: :infinity)

%{1 => one_count, 3 => three_count} =
  Enum.zip(voltages, Enum.drop(voltages, 1))
  |> Enum.map(fn {a, b} -> b - a end)
  |> IO.inspect(limit: :infinity)
  |> Enum.frequencies()

((one_count + 1) * (three_count + 1))
|> IO.inspect()
