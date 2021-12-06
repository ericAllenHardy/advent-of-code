defmodule Star do
  def list_to_binary(bits) do
    Enum.reduce(bits, 0, fn bit, n ->
      2 * n + String.to_integer(bit)
    end)
  end
end

lines =
  File.read!("./input.txt")
  |> String.split("\n")
  |> Enum.map(&String.codepoints/1)

gamma_rate =
  lines
  |> Enum.zip_with(fn column_items ->
    %{"1" => one_count, "0" => zero_count} = Enum.frequencies(column_items)

    if one_count >= zero_count, do: "1", else: "0"
  end)

epsilon_rate =
  Enum.map(gamma_rate, fn n ->
    case n do
      "1" -> "0"
      "0" -> "1"
    end
  end)

IO.puts(Star.list_to_binary(gamma_rate) * Star.list_to_binary(epsilon_rate))
