defmodule Star do
  def tuple_to_binary(bits) do
    Tuple.to_list(bits)
    |> Enum.reduce(0, fn bit, n -> 2 * n + bit end)
  end

  def most_frequent(column_values) do
    counts = Enum.frequencies(column_values)

    if Map.get(counts, 1, 0) >= Map.get(counts, 0, 0), do: 1, else: 0
  end

  def least_frequent(column_values) do
    Star.most_frequent(column_values) |> (&(1 - &1)).()
  end

  def filter_lines_by(lines, criteria_fn), do: filter_lines_by_at(lines, criteria_fn, 0)

  defp filter_lines_by_at([], _filter, _i), do: nil
  defp filter_lines_by_at([line], _, _i), do: line

  defp filter_lines_by_at(lines, criteria_fn, i) do
    expected_bit =
      Enum.map(lines, &elem(&1, i))
      |> criteria_fn.()

    Enum.filter(lines, &(elem(&1, i) == expected_bit))
    |> filter_lines_by(criteria_fn, i + 1)
  end
end

lines =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(fn s ->
    String.codepoints(s)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end)

oxygen_generator_rating =
  Star.filter_lines_by(lines, &Star.most_frequent/1)
  |> Star.tuple_to_binary()

c02_scrubber_rating =
  Star.filter_lines_by(lines, &Star.least_frequent/1)
  |> Star.tuple_to_binary()

IO.puts(oxygen_generator_rating * c02_scrubber_rating)
