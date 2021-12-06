defmodule Game do
  def new(inputs) do
    %{
      item: List.last(inputs),
      current_round: length(inputs),
      seen:
        inputs
        |> Stream.with_index()
        |> Enum.into(%{})
    }
  end

  def iterate(game) do
    item =
      case Map.get(game.seen, game.item) do
        nil -> 0
        last_seen -> game.current_round - 1 - last_seen
      end

    # IO.puts("Round #{game.current_round + 1} - say #{item}")

    %{
      item: item,
      current_round: game.current_round + 1,
      seen: Map.put(game.seen, game.item, game.current_round - 1)
    }
  end

  def run(game, 0), do: game
  def run(game, n), do: run(iterate(game), n - 1)
end

inputs =
  File.read!("input.txt")
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

inputs
|> Game.new()
|> Game.run(30_000_000 - length(inputs))
|> (& &1.item).()
|> IO.puts()
