defmodule Mask do
  use Bitwise

  def parse_line(s) do
    String.split(s, [" = ", "]", "["])
    |> case do
      ["mask", mask] -> {:mask, parse_mask(mask)}
      ["mem", addr, _, input] -> {:mem, String.to_integer(addr), String.to_integer(input)}
    end
  end

  defp parse_mask(s) do
    {
      s |> String.replace("X", "1") |> String.to_integer(2),
      s |> String.replace("X", "0") |> String.to_integer(2)
    }
  end

  def apply_mask(n, {set_zeros, set_ones}),
    do: n |> band(set_zeros) |> bor(set_ones)

  def load_memory({:mask, new_mask}, {memory, mask}), do: {memory, new_mask}

  def load_memory({:mem, addr, value}, {memory, mask}),
    do: {Map.put(memory, addr, apply_mask(value, mask)), mask}
end

File.read!("input.txt")
|> String.split("\n")
|> Enum.map(&Mask.parse_line/1)
|> Enum.reduce({%{}, nil}, &Mask.load_memory/2)
|> elem(0)
|> Map.values()
|> Enum.sum()

# |> Enum.sum()
|> IO.inspect(limit: :infinity)
