defmodule IntCode do
  def parse(int_code) do
    int_code
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def run(integers) do
    run(integers, 0)
  end

  defp run(integers, index) do
    if index >= length(integers) do
      integers
    else
      [op, a, b, save_posn] = Enum.slice(integers, Range.new(index, index + 3))

      case apply_op(integers, op, a, b, save_posn) do
        {:continue, new_integers} ->
          run(new_integers, index + 4)

        :halt ->
          integers
      end
    end
  end

  defp apply_op(integers, op, a, b, save_posn) do
    case op do
      1 ->
        sum = Enum.at(integers, a) + Enum.at(integers, b)
        {:continue, List.update_at(integers, save_posn, fn _ -> sum end)}

      2 ->
        product = Enum.at(integers, a) * Enum.at(integers, b)
        {:continue, List.update_at(integers, save_posn, fn _ -> product end)}

      99 ->
        :halt
    end
  end

  def show(integers) do
    integers
    |> word_chunks()
    |> Enum.map(&show_word/1)
    |> Enum.join("\n")
  end

  defp show_word(word) do
    word |> Enum.map(&Integer.to_string/1) |> Enum.join(",")
  end

  defp word_chunks(integers) do
    if length(integers) >= 4 do
      [Enum.take(integers, 4) | word_chunks(Enum.drop(integers, 4))]
    else
      [integers]
    end
  end
end
