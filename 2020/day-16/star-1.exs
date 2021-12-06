defmodule Ticket do
  def ticket_valid?(rules, ticket) do
    Enum.all?(ticket, fn entry ->
      Enum.any?(rules, fn {_, range} -> in_range?(range, entry) end)
    end)
  end

  def rule_satisfied?(rule_range, ticket_column),
    do: Enum.all?(ticket_column, &in_range?(rule_range, &1))

  defp in_range?({r_1_min..r_1_max, r_2_min..r_2_max}, n),
    do: (r_1_min <= n and n <= r_1_max) or (r_2_min <= n and n <= r_2_max)

  def solve_assignments(valid_assignment_map),
    do: solve_assignments(valid_assignment_map, %{})

  def solve_assignments(valid_assignment_map, assignments) when valid_assignment_map == %{},
    do: assignments

  def solve_assignments(valid_assignment_map, assignments) do
    case Enum.find(valid_assignment_map, nil, fn {_rule, options} -> length(options) == 1 end) do
      {rule, [column]} ->
        solve_assignments(
          valid_assignment_map
          |> Stream.map(fn {r, os} -> {r, Enum.filter(os, &(&1 !== column))} end)
          |> Stream.filter(fn {_r, os} -> not Enum.empty?(os) end)
          |> Enum.into(%{}),
          Map.put(assignments, rule, column)
        )
    end
  end
end

[rules_block, my_ticket_block, tickets_block] = File.read!("input.txt") |> String.split("\n\n")

rules =
  rules_block
  |> String.split("\n")
  |> Stream.map(fn line ->
    [name, range_1_l, range_1_r, range_2_l, range_2_r] = String.split(line, [": ", " or ", "-"])

    {name,
     {
       Range.new(String.to_integer(range_1_l), String.to_integer(range_1_r)),
       Range.new(String.to_integer(range_2_l), String.to_integer(range_2_r))
     }}
  end)
  |> Enum.into(%{})

my_ticket =
  my_ticket_block
  |> String.split("\n")
  |> List.last()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

tickets =
  tickets_block
  |> String.split("\n")
  |> Enum.drop(1)
  |> Enum.map(fn line ->
    line |> String.split(",") |> Enum.map(&String.to_integer/1)
  end)

valid_tickets = [my_ticket | Enum.filter(tickets, &Ticket.ticket_valid?(rules, &1))]

for i <- 0..(length(my_ticket) - 1),
    {name, range} <- rules,
    ticket_column = valid_tickets |> Enum.map(&Enum.at(&1, i)),
    Ticket.rule_satisfied?(range, ticket_column) do
  {name, i}
end
|> Enum.reduce(%{}, fn {name, i}, map -> Map.update(map, name, [i], &[i | &1]) end)
|> Ticket.solve_assignments()
|> IO.inspect()
|> Enum.reduce(1, fn {name, i}, acc ->
  if(String.starts_with?(name, "departure"), do: Enum.at(my_ticket, i) * acc, else: acc)
end)
|> IO.inspect()
