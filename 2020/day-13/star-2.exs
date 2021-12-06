defmodule Modular do
  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * if(a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}

  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient * x, y, last_y - quotient * y)
  end

  def inverse(e, et) do
    {g, x} = extended_gcd(e, et)

    if g != 1 do
      IO.inspect({{e, et}, {g, x}})
      raise("The maths are broken!")
    end

    rem(x + et, et)
  end
end

schedules =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.at(1)
  |> String.split(",")
  |> Stream.with_index()
  |> Enum.reduce([], fn {n, i}, ls ->
    if n == "x" do
      ls
    else
      [{String.to_integer(n), -i} | ls]
    end
  end)
  |> Enum.reverse()

IO.inspect(schedules)

n =
  schedules
  |> Enum.reduce(fn {p, a}, {q, b} ->
    new_mod = (p * q) |> Integer.floor_div(Integer.gcd(p, q))

    new_x =
      (a * q * Modular.inverse(q, p) + b * p * Modular.inverse(p, q)) |> Integer.mod(new_mod)

    {new_mod, new_x}
    |> IO.inspect()
  end)
  |> elem(1)
  |> IO.inspect()

schedules
|> Enum.each(fn {p, a} -> IO.puts("#{n} mod #{p} = #{Integer.mod(n, p)} (espect #{a})") end)
