defmodule Ship do
  @type direction() :: :east | :north | :west | :south
  @type t() :: %{
          x: integer(),
          y: integer(),
          direction: direction()
        }

  def parse_instruction(s) do
    case String.split_at(s, 1) do
      {"N", n} -> {:north, String.to_integer(n)}
      {"S", n} -> {:south, String.to_integer(n)}
      {"E", n} -> {:east, String.to_integer(n)}
      {"W", n} -> {:west, String.to_integer(n)}
      {"L", n} -> {:left, String.to_integer(n) |> Integer.floor_div(90)}
      {"R", n} -> {:right, String.to_integer(n) |> Integer.floor_div(90)}
      {"F", n} -> {:forward, String.to_integer(n)}
    end
  end

  def turn_left(direction, 0), do: direction
  def turn_left(direction, n), do: turn_left(direction) |> turn_left(n - 1)

  def turn_left(:east), do: :north
  def turn_left(:north), do: :west
  def turn_left(:west), do: :south
  def turn_left(:south), do: :east

  def turn_right(direction, 0), do: direction
  def turn_right(direction, n) when n > 0, do: turn_right(direction) |> turn_right(n - 1)

  def turn_right(:east), do: :south
  def turn_right(:south), do: :west
  def turn_right(:west), do: :north
  def turn_right(:north), do: :east

  def new(), do: %{x: 0, y: 0, direction: :east}

  def move(ship, {:north, n}), do: %{ship | y: ship.y + n}
  def move(ship, {:south, n}), do: %{ship | y: ship.y - n}
  def move(ship, {:east, n}), do: %{ship | x: ship.x + n}
  def move(ship, {:west, n}), do: %{ship | x: ship.x - n}
  def move(ship, {:left, n}), do: %{ship | direction: turn_left(ship.direction, n)}
  def move(ship, {:right, n}), do: %{ship | direction: turn_right(ship.direction, n)}
  def move(ship, {:forward, n}), do: move(ship, {ship.direction, n})
end

instructions =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&Ship.parse_instruction/1)

final_ship =
  Enum.reduce(instructions, Ship.new(), fn move, ship ->
    IO.inspect(ship)
    IO.inspect(move)
    Ship.move(ship, move)
  end)

IO.puts(abs(final_ship.x) + abs(final_ship.y))
