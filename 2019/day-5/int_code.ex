defmodule IntCode do
  def parse(int_code) do
    int_code
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def run(program), do: run(program, 0)

  defp run(program, index) do
    IO.inspect({index, Enum.at(program, index)}, label: "index, op")
    op = Enum.at(program, index) |> parse_op()

    case apply_op(program, index, op) do
      {:continue, new_program, new_index} -> run(new_program, new_index)
      :halt -> program
    end
  end

  defp parse_op(int_op) when is_integer(int_op) do
    digits = Integer.digits(int_op)
    [param3, param2, param1, op1, op2] = List.duplicate(0, 5 - length(digits)) ++ digits

    %{
      op_code: Integer.undigits([op1, op2]),
      param_1: parse_param_mode(param1),
      param_2: parse_param_mode(param2),
      param_3: parse_param_mode(param3)
    }
  end

  defp parse_param_mode(0), do: :position
  defp parse_param_mode(1), do: :immediate

  defp get_param(_program, :immediate, value), do: value
  defp get_param(program, :position, posn), do: Enum.at(program, posn)

  defp apply_op(program, index, op) do
    case op.op_code do
      1 -> apply_add(program, index, op)
      2 -> apply_multiply(program, index, op)
      3 -> apply_input(program, index, op)
      4 -> apply_output(program, index, op)
      5 -> apply_jump_if_true(program, index, op)
      6 -> apply_jump_if_false(program, index, op)
      7 -> apply_less_than(program, index, op)
      8 -> apply_equals(program, index, op)
      99 -> :halt
    end
  end

  defp apply_add(program, index, param_modes) do
    [a, b, save_posn] = Enum.slice(program, Range.new(index + 1, index + 3))
    sum = get_param(program, param_modes.param_1, a) + get_param(program, param_modes.param_2, b)
    {:continue, List.update_at(program, save_posn, fn _ -> sum end), index + 4}
  end

  defp apply_multiply(program, index, param_modes) do
    [a, b, save_posn] = Enum.slice(program, Range.new(index + 1, index + 3))

    product =
      get_param(program, param_modes.param_1, a) * get_param(program, param_modes.param_2, b)

    {:continue, List.update_at(program, save_posn, fn _ -> product end), index + 4}
  end

  defp apply_less_than(program, index, param_modes) do
    [a, b, save_posn] = Enum.slice(program, Range.new(index + 1, index + 3))

    value =
      if get_param(program, param_modes.param_1, a) < get_param(program, param_modes.param_2, b),
        do: 1,
        else: 0

    {:continue, List.update_at(program, save_posn, fn _ -> value end), index + 4}
  end

  defp apply_equals(program, index, param_modes) do
    [a, b, save_posn] = Enum.slice(program, Range.new(index + 1, index + 3))

    value =
      if get_param(program, param_modes.param_1, a) == get_param(program, param_modes.param_2, b),
        do: 1,
        else: 0

    {:continue, List.update_at(program, save_posn, fn _ -> value end), index + 4}
  end

  def apply_input(program, index, _param_modes) do
    input_int = IO.gets("Input please\n") |> String.trim() |> String.to_integer()
    save_posn = Enum.at(program, index + 1)
    {:continue, List.update_at(program, save_posn, fn _ -> input_int end), index + 2}
  end

  def apply_output(program, index, param_modes) do
    load_posn = Enum.at(program, index + 1)

    get_param(program, param_modes.param_1, load_posn)
    |> Integer.to_string()
    |> IO.puts()

    {:continue, program, index + 2}
  end

  defp apply_jump_if_true(program, index, param_modes) do
    [compare, jump_posn] = Enum.slice(program, Range.new(index + 1, index + 2))

    new_index =
      if get_param(program, param_modes.param_1, compare) != 0, do: jump_posn, else: index + 3

    {:continue, program, new_index}
  end

  defp apply_jump_if_false(program, index, param_modes) do
    [compare, jump_posn] = Enum.slice(program, Range.new(index + 1, index + 2))

    new_index =
      if get_param(program, param_modes.param_1, compare) == 0, do: jump_posn, else: index + 3

    {:continue, program, new_index}
  end
end
