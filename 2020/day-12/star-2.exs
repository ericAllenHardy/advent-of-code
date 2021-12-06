defmodule Ship do
  @type t() :: %{
          boat_x: integer(),
          boat_y: integer(),
          waypoint_x: integer(),
          waypoint_y: integer()
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

  def turn_left(ship, 0), do: ship
  def turn_left(ship, n), do: turn_left(ship) |> turn_left(n - 1)

  def turn_left(ship), do: %{ship | waypoint_x: -ship.waypoint_y, waypoint_y: ship.waypoint_x}

  def turn_right(ship, 0), do: ship
  def turn_right(ship, n), do: turn_right(ship) |> turn_right(n - 1)

  def turn_right(ship), do: %{ship | waypoint_x: ship.waypoint_y, waypoint_y: -ship.waypoint_x}

  def new(), do: %{boat_x: 0, boat_y: 0, waypoint_x: 10, waypoint_y: 1}

  def move(ship, {:north, n}), do: %{ship | waypoint_y: ship.waypoint_y + n}
  def move(ship, {:south, n}), do: %{ship | waypoint_y: ship.waypoint_y - n}
  def move(ship, {:east, n}), do: %{ship | waypoint_x: ship.waypoint_x + n}
  def move(ship, {:west, n}), do: %{ship | waypoint_x: ship.waypoint_x - n}
  def move(ship, {:left, n}), do: turn_left(ship, n)
  def move(ship, {:right, n}), do: turn_right(ship, n)

  def move(ship, {:forward, n}),
    do: %{
      ship
      | boat_x: ship.boat_x + n * ship.waypoint_x,
        boat_y: ship.boat_y + n * ship.waypoint_y
    }
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

IO.puts(abs(final_ship.boat_x) + abs(final_ship.boat_y))
