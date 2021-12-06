defmodule Seating do
  def to_id(s) do
    {row, col} = String.split_at(s, -3)

    calc_val(String.codepoints(row), 0, 127) * 8 + calc_val(String.codepoints(col), 0, 7)
  end

  defp calc_val([], min, max) when min == max, do: min

  defp calc_val([c | chars], min, max) when c in ["F", "L"] do
    range = max - min + 1
    calc_val(chars, min, max - range / 2)
  end

  defp calc_val([c | chars], min, max) when c in ["B", "R"] do
    range = max - min + 1
    calc_val(chars, min + range / 2, max)
  end
end

File.read!("input.txt")
|> String.split("\n")
|> Enum.sort_by(fn s ->
  s
  |> String.codepoints()
  |> Enum.map(fn c ->
    case c do
      "F" -> 1
      "B" -> -1
      "R" -> -1
      "L" -> 1
    end
  end)
end)
|> Enum.at(0)
|> Seating.to_id()
# |> Enum.map(&Seating.to_id/1)
# |> Enum.max(-1)
|> IO.inspect()
