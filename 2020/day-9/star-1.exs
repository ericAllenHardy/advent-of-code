defmodule XMAS do
  def find_invalid({preamble, xs}), do: find_invalid(preamble, xs)

  def find_invalid(preamble = [_ | ps], [x | xs]) do
    set25 = MapSet.new(preamble)

    Enum.filter(set25, &MapSet.member?(set25, x - &1))
    |> case do
      [] -> x
      _ -> find_invalid(ps ++ [x], xs)
    end
  end

  # {min: , max: , range_sum: }
  #

  def consecutives(numbers, target_value) do
    array = List.to_tuple(numbers)
    consecutives(array, target_value, 0, 1, elem(array, 0) + elem(array, 1))
  end

  def consecutives(numbers, target, l_index, r_index, range_sum) do
    cond do
      range_sum == target ->
        range = Enum.slice(numbers, Range.new(l_index, r_index))
        Enum.reduce(range, &min/2) + Enum.reduce(range, &max/2)

      range_sum < target ->
        consecutives(
          numbers,
          target,
          l_index,
          r_index + 1,
          range_sum + elem(numbers, r_index + 1)
        )

      range_sum > target ->
        :error
    end
  end

  def consecutive_n2(numbers, target_value) do
    {range, _} =
      for l <- 0..(length(numbers) - 2),
          r <- 1..(length(numbers) - 1) do
        range = Enum.slice(numbers, l..r)
        {range, Enum.sum(range)}
      end
      |> Enum.filter(fn {_, total} -> total == target_value end)
      |> List.first()

    Enum.reduce(range, &min/2) + Enum.reduce(range, &max/2)
  end
end

numbers =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

invalid_number =
  numbers
  |> Enum.split(25)
  |> XMAS.find_invalid()

XMAS.consecutive_n2(numbers, invalid_number)
|> IO.puts()
