defmodule NewMath do
  def eval([n | expr]) when is_integer(n), do: eval(expr, n)

  def eval(["(" | expr]) do
    {se, rest} = sub_expr(expr)
    eval(rest, eval(se))
  end

  def eval([], acc), do: acc
  def eval(["+", n | expr], acc) when is_integer(n), do: eval(expr, acc + n)

  def eval(["+", "(" | expr], acc) do
    {se, rest} = sub_expr(expr)
    eval(rest, acc + eval(se))
  end

  def eval(["*", n | expr], acc) when is_integer(n), do: eval(expr, acc * n)

  def eval(["*", "(" | expr], acc) do
    {se, rest} = sub_expr(expr)
    eval(rest, acc * eval(se))
  end

  defp sub_expr(expr), do: sub_expr(expr, [])

  defp sub_expr(["(" | expr], se) do
    {inner_se, rest} = sub_expr(expr)
    sub_expr(rest, [eval(inner_se) | se])
  end

  defp sub_expr([")" | expr], se), do: {Enum.reverse(se), expr}
  defp sub_expr([x | expr], se), do: sub_expr(expr, [x | se])
end

File.read!("input.txt")
|> String.split("\n")
|> Stream.map(fn line ->
  line
  |> String.codepoints()
  |> Stream.filter(&(&1 != " "))
  |> Stream.map(fn item ->
    case Integer.parse(item) do
      {n, ""} -> n
      _ -> item
    end
  end)
  |> Enum.to_list()
end)
|> Stream.map(&NewMath.eval/1)
|> Enum.sum()
|> IO.inspect()
