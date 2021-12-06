defmodule Star do
  @type board :: %{
          board: %{integer() => {integer(), integer()}},
          seen: MapSet.t({integer(), integer()})
        }

  def parse(file) do
    [draws | boards] = File.read!(file) |> String.split("\n\n")

    {
      draws |> String.split(",") |> Enum.map(&String.to_integer/1),
      boards |> Enum.map(&parse_board/1)
    }
  end

  defp parse_board(board_chunk) do
    board =
      for {line, r} <- String.split(board_chunk, "\n") |> Enum.with_index(),
          {n, c} <- String.split(line) |> Enum.with_index(),
          into: %{} do
        {String.to_integer(n), {r, c}}
      end

    %{
      board: board,
      seen: MapSet.new()
    }
  end

  def not_seen(%{board: board, seen: seen}) do
    board
    |> Enum.filter(fn {_n, coord} -> not MapSet.member?(seen, coord) end)
    |> Enum.map(&elem(&1, 0))
  end

  def update_board_with_draw(%{board: board, seen: seen}, draw) do
    %{
      board: board,
      seen:
        case Map.get(board, draw) do
          nil -> seen
          coord -> MapSet.put(seen, coord)
        end
    }
  end

  def board_wins?(board), do: row_match?(board.seen) or col_match?(board.seen)

  defp row_match?(seen) do
    Enum.find(0..5, fn row ->
      Enum.count(seen, fn {r, _c} -> r == row end) == 5
    end) != nil
  end

  defp col_match?(seen) do
    Enum.find(0..5, fn col ->
      Enum.count(seen, fn {_r, c} -> c == col end) == 5
    end) != nil
  end
end

{draws, boards} = Star.parse("./input.txt")

{draw, board} =
  Enum.reduce_while(draws, boards, fn draw, boards ->
    new_boards = Enum.map(boards, &Star.update_board_with_draw(&1, draw))

    case Enum.find(new_boards, nil, &Star.board_wins?/1) do
      nil -> {:cont, new_boards}
      board -> {:halt, {draw, board}}
    end
  end)

IO.inspect({draw, Star.not_seen(board)})
IO.puts(draw * Enum.sum(Star.not_seen(board)))
