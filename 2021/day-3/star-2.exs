defmodule Star do
  def list_to_binary(bits) do
    Tuple.to_list(bits)
    |> Enum.reduce(0, fn bit, n ->
      2 * n + String.to_integer(bit)
    end)
  end

  def pick_most_frequent(items) do
    counts = Enum.frequencies(items)

    if Map.get(counts, "1", 0) >= Map.get(counts, "0", 0), do: "1", else: "0"
  end

  def pick_least_frequent(items) do
    items
    |> Star.pick_most_frequent()
    |> case do
      "1" -> "0"
      "0" -> "1"
    end
  end

  def filter_lines([], _filter, _i), do: nil
  def filter_lines([line], _, _i), do: line

  def filter_lines(lines, criteria_fn, i) do
    bit_criteria =
      lines
      |> Enum.map(&elem(&1, i))
      |> criteria_fn.()

    lines
    |> Enum.filter(&(elem(&1, i) == bit_criteria))
    |> filter_lines(criteria_fn, i + 1)
  end

  def filter_lines(criteria_fn, lines), do: filter_lines(lines, criteria_fn, 0)
end

lines =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(fn s -> String.codepoints(s) |> List.to_tuple() end)

oxygen_generator_rating =
  Star.filter_lines(&Star.pick_most_frequent/1, lines)
  |> Star.list_to_binary()

c02_scrubber_rating =
  Star.filter_lines(&Star.pick_least_frequent/1, lines)
  |> Star.list_to_binary()

IO.puts(oxygen_generator_rating * c02_scrubber_rating)
