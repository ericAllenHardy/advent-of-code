{first_time, schedules} =
  File.read!("input.txt")
  |> String.split("\n")
  |> case do
    [first_timestamp, schedules] ->
      {
        String.to_integer(first_timestamp),
        String.split(schedules, ",")
        |> Enum.reduce([], fn item, ls ->
          if item == "x" do
            ls
          else
            [String.to_integer(item) | ls]
          end
        end)
      }
  end

IO.inspect({first_time, schedules})

best_schedule =
  schedules
  |> Enum.map(&(&1 - Integer.mod(first_time, &1)))
  |> Enum.with_index()
  |> Enum.min_by(&elem(&1, 0))
  |> (&Enum.at(schedules, elem(&1, 1))).()
  |> IO.inspect()

IO.puts((best_schedule - Integer.mod(first_time, best_schedule)) * best_schedule)
