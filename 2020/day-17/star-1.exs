defmodule Cubes do
  # coord order is z, y, x
  def new(inputFile) do
    File.read!(inputFile)
    |> String.split("\n")
    |> Stream.with_index()
    |> Stream.map(fn {line, y} ->
      String.codepoints(line)
      |> Stream.with_index()
      |> Stream.filter(fn {cell, _} -> cell == "#" end)
      |> Stream.map(fn {_, x} -> {x, y, 0} end)
    end)
    |> Stream.concat()
    |> Enum.into(MapSet.new())
  end

  def iterate(grid) do
    neighbours_of_active(grid)
    |> Enum.reduce(grid, fn {coord, count}, new_grid ->
      cond do
        count == 3 -> MapSet.put(new_grid, coord)
        MapSet.member?(grid, coord) and count == 2 -> new_grid
        true -> MapSet.delete(new_grid, coord)
      end
    end)
  end

  def iterate(grid, 0), do: grid

  def iterate(grid, n) do
    g = iterate(grid)
    print(g)
    iterate(g, n - 1)
  end

  defp neighbours_of_active(grid) do
    for {x, y, z} <- grid,
        zp <- -1..1,
        yp <- -1..1,
        xp <- -1..1,
        not (zp == yp and yp == xp and xp == 0) do
      {x + xp, y + yp, z + zp}
    end
    |> Enum.reduce(%{}, fn coord, map -> Map.update(map, coord, 1, &(&1 + 1)) end)
  end

  def count_active(grid), do: MapSet.size(grid)

  def print(grid) do
    {x_min, x_max} = grid |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {y_min, y_max} = grid |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    {z_min, z_max} = grid |> Enum.map(&elem(&1, 2)) |> Enum.min_max()

    IO.puts("Max: (#{x_max}, #{y_max}, #{z_max})")
    IO.puts("Min: (#{x_min}, #{y_min}, #{z_min})")

    for z <- z_min..z_max do
      layer =
        for y <- y_min..y_max do
          for x <- x_min..x_max do
            if(MapSet.member?(grid, {x, y, z}), do: "#", else: ".")
          end
          |> Enum.join()
        end
        |> Enum.join("\n")

      ["z=#{z}", layer] |> Enum.join("\n")
    end
    |> Enum.join("\n\n")
    |> IO.puts()

    grid
  end
end

Cubes.new("input2.txt")
|> Cubes.print()
|> Cubes.iterate(6)
|> Cubes.count_active()
|> IO.puts()
