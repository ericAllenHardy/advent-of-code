defmodule Seats do
  @type cell() :: :floor | :empty | :filled
  @type t() :: %{
          height: integer(),
          width: integer(),
          cells: %{integer() => %{integer() => cell()}}
        }

  def parse_grid(lines) do
    %{
      height: lines |> length(),
      width: lines |> List.first() |> length(),
      cells: lines |> to_map_with(fn line -> line |> to_map_with(&parse_cell/1) end)
    }
  end

  defp parse_cell(c) do
    case c do
      "." -> :floor
      "L" -> :empty
      "#" -> :Filled
    end
  end

  defp unparse_cell(c) do
    case c do
      :floor -> "."
      :empty -> "L"
      :filled -> "#"
    end
  end

  defp to_map_with(ls, func) do
    ls
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {v, k}, acc -> Map.put(acc, k, func.(v)) end)
  end

  def to_string(grid) do
    grid.cells
    |> to_string_with(
      grid.height,
      fn row -> row |> to_string_with(grid.width, &unparse_cell/1, "") end,
      "\n"
    )
  end

  defp to_string_with(map, len, func, joiner) when not is_nil(map) do
    0..(len - 1)
    |> Enum.map(fn i -> Map.get(map, i) |> func.() end)
    |> Enum.join(joiner)
  end

  def iterate(grid) do
    new_cells =
      Enum.into(grid.cells, %{}, fn {i, row} ->
        {i, Enum.into(row, %{}, fn {j, cell} -> {j, iterate_cell(grid, cell, i, j)} end)}
      end)

    %{grid | cells: new_cells}
  end

  defp iterate_cell(_grid, :floor, _i, _j), do: :floor

  defp iterate_cell(grid, :empty, i, j) do
    neighbours(grid, i, j)
    |> Enum.any?(fn c -> c === :filled end)
    |> case do
      true -> :empty
      false -> :filled
    end
  end

  defp iterate_cell(grid, :filled, i, j) do
    neighbours(grid, i, j)
    |> Enum.count(fn c -> c === :filled end)
    |> case do
      n when n < 4 -> :filled
      _ -> :empty
    end
  end

  defp neighbours(grid, i, j) do
    for i_adj <- (i - 1)..(i + 1),
        j_adj <- (j - 1)..(j + 1),
        i_adj >= 0 and i_adj < grid.height,
        j_adj >= 0 and j_adj < grid.width,
        i_adj !== i or j_adj !== j do
      grid.cells |> Map.get(i_adj) |> Map.get(j_adj)
    end
  end

  def converge(grid) do
    grid2 = iterate(grid)

    if grid2 == grid do
      grid2
    else
      grid2 |> Seats.to_string() |> IO.puts()
      converge(grid2)
    end
  end

  def count_filled(grid) do
    grid.cells
    |> Map.values()
    |> Enum.reduce(0, fn row, count ->
      count +
        (Map.values(row)
         |> Enum.reduce(0, fn cell, sub_count ->
           sub_count +
             case cell do
               :filled -> 1
               _ -> 0
             end
         end))
    end)
  end
end

grid =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&String.codepoints/1)
  |> Seats.parse_grid()

# IO.inspect(grid)
grid |> Seats.to_string() |> IO.puts()

final_grid = Seats.converge(grid)
final_grid |> Seats.count_filled() |> IO.puts()
