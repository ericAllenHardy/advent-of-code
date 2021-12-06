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
    %{
      board:
        for {line, r} <- String.split(board_chunk, "\n") |> Enum.with_index(),
            {n, c} <- String.split(line) |> Enum.with_index(),
            into: %{} do
          {String.to_integer(n), {r, c}}
        end,
      seen: MapSet.new()
    }
  end

  def not_seen(board) do
    board.board
    |> Enum.filter(fn {_n, coord} -> not MapSet.member?(board.seen, coord) end)
    |> Enum.map(&elem(&1, 0))
  end

  def add_draw_to_board(board, draw) do
    case Map.get(board.board, draw) do
      nil -> board
      coord -> %{board | seen: MapSet.put(board.seen, coord)}
    end
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
    new_boards = Enum.map(boards, &Star.add_draw_to_board(&1, draw))

    new_boards
    |> Enum.filter(&(not Star.board_wins?(&1)))
    |> case do
      [] ->
        {:halt, {draw, List.first(new_boards)}}

      boards_still_in_play ->
        {:cont, boards_still_in_play}
    end
  end)

IO.puts(draw * Enum.sum(Star.not_seen(board)))
