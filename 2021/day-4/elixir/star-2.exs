defmodule Star do
  @type board :: %{
          board: %{integer() => {integer(), integer()}},
          seen: MapSet.t({integer(), integer()})
        }

  def parse(file) do
    [draws_line | board_chunks] =
      File.read!(file)
      |> String.split("\n\n")

    draws = draws_line |> String.split(",") |> Enum.map(&String.to_integer/1)
    boards = board_chunks |> Enum.map(&parse_board/1)

    {draws, boards}
  end

  defp parse_board(board_chunk) do
    %{
      board:
        for {line, r} <- board_chunk |> String.split("\n") |> Enum.with_index(),
            {n, c} <- line |> String.split() |> Enum.with_index(),
            into: %{} do
          {String.to_integer(n), {r, c}}
        end,
      seen: MapSet.new()
    }
  end

  def add_draw_to_board(board, draw) do
    case Map.get(board.board, draw) do
      nil -> board
      coord -> %{board | seen: MapSet.put(board.seen, coord)}
    end
  end

  def board_wins?(board) do
    row_match =
      for i <- 0..5 do
        row_items = Enum.filter(board.seen, fn {r, _c} -> r == i end)
        length(row_items) == 5
      end
      |> Enum.any?(&(length(&1) == 5))

    col_match =
      for i <- 0..5 do
        col_items = Enum.filter(board.seen, fn {_r, c} -> c == i end)
        length(col_items) == 5
      end
      |> Enum.any?()

    row_match or col_match
  end

  def not_seen(board) do
    board.board
    |> Enum.filter(fn {_n, coord} -> not MapSet.member?(board.seen, coord) end)
    |> Enum.map(&elem(&1, 0))
  end
end

{draws, boards} = Star.parse("./input.txt")

{draw, board} =
  Enum.reduce_while(draws, boards, fn draw, boards ->
    new_boards = Enum.map(boards, &Star.add_draw_to_board(&1, draw))

    case Enum.filter(new_boards, fn b -> not Star.board_wins?(b) end) do
      [] ->
        {:halt, {draw, List.first(new_boards)}}

      boards_still_in_play ->
        {:cont, boards_still_in_play}
    end
  end)

IO.puts(draw * Enum.sum(Star.not_seen(board)))
