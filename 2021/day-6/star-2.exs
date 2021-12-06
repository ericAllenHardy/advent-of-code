defmodule Star do
  def step(counts) do
    case Map.pop(counts, 0) do
      {nil, rest} ->
        rest |> decrement_counts()

      {n, rest} ->
        rest |> decrement_counts() |> Map.update(6, n, &(&1 + n)) Map.put(8, n)
    end
  end

  defp decrement_counts(cs),
    do: Enum.map(cs, fn {day, count} -> {day - 1, count} end) |> Enum.into(%{})

  def repeat(value, 0, _func), do: value
  def repeat(value, n, func), do: repeat(func.(value), n - 1, func)
end

File.read!("./input.txt")
|> String.split(",")
|> Enum.map(&String.to_integer/1)
|> Enum.frequencies()
|> Star.repeat(256, &Star.step/1)
|> Map.values()
|> Enum.sum()
|> IO.inspect()
