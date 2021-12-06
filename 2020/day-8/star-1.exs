defmodule Handheld do
  def parse_instruction(line) do
    [op, n] = String.split(line, " ")
    {op, String.to_integer(n)}
  end

  def eval(instructions), do: eval(MapSet.new(), 0, 0, instructions)

  defp eval(seen, acc, index, instructions) do
    if MapSet.member?(seen, index), do: IO.puts("STARTING THE LOOP")

    cond do
      index >= length(instructions) ->
        {:ok, acc}

      MapSet.member?(seen, index) ->
        {:error, acc}

      true ->
        new_seen = MapSet.put(seen, index)

        IO.inspect([index, Enum.at(instructions, index)], label: "index, op")

        case Enum.at(instructions, index) do
          {"acc", add} ->
            eval(new_seen, acc + add, index + 1, instructions)

          {"nop", offset} ->
            new_index = index + if MapSet.member?(new_seen, index + 1), do: offset, else: 1

            eval(new_seen, acc, new_index, instructions)

          {"jmp", offset} ->
            new_index = index + if MapSet.member?(new_seen, index + offset), do: 1, else: offset

            eval(new_seen, acc, new_index, instructions)
        end
    end
  end
end

File.read!("input.txt")
|> String.split("\n")
|> Enum.map(&Handheld.parse_instruction/1)
|> Handheld.eval()
|> IO.inspect()
