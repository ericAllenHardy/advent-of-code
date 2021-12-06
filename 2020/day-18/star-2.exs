defmodule NewMath do
  def ast(terms), do: ast(terms, nil)

  def ast([], tree), do: tree
  def ast([n | terms], tree) when is_integer(n), do: ast(terms, insert(tree, n))
  def ast(["+" | terms], tree), do: ast(terms, add(tree))
  def ast(["*" | terms], tree), do: ast(terms, mult(tree))  
  def ast(["(" | terms], tree), do: ast(terms, insert(tree, {:partial_parens, nil}))

  def ast([")" | terms], tree),
    do:
      ast(
        terms,
        case close_parens(tree) do
          :unchanged -> tree
          new_tree -> new_tree
        end
      )

  def insert(nil, x), do: x
  def insert({:+, a, b}, x), do: {:+, a, insert(b, x)}
  def insert({:*, a, b}, x), do: {:*, a, insert(b, x)}
  def insert({:partial_parens, tree}, x), do: {:partial_parens, insert(tree, x)}

  def close_parens(n) when is_integer(n), do: :unchanged
  def close_parens({:parens, _}), do: :unchanged

  def close_parens({:+, a, b}) do
    case close_parens(b) do
      :unchanged -> :unchanged
      new_b -> {:+, a, new_b}
    end
  end

  def close_parens({:*, a, b}) do
    case close_parens(b) do
      :unchanged -> :unchanged
      new_b -> {:*, a, new_b}
    end
  end

  def close_parens({:partial_parens, tree}) do
    case close_parens(tree) do
      :unchanged -> {:parens, tree}
      new_tree -> {:partial_parens, new_tree}
    end
  end

  defp add(n) when is_integer(n), do: {:+, n, nil}
  defp add({:partial_parens, tree}), do: {:partial_parens, add(tree)}
  defp add(tree = {:parens, _}), do: {:+, tree, nil}
  defp add({:+, a, b = {:partial_parens, _}}), do: {:+, a, add(b)}
  defp add(tree = {:+, _, _}), do: {:+, tree, nil}
  defp add({:*, a, b}), do: {:*, a, add(b)}

  defp mult(n) when is_integer(n), do: {:*, n, nil}
  defp mult({:partial_parens, tree}), do: {:partial_parens, mult(tree)}
  defp mult({:+, a, {:partial_parens, tree}}), do: {:+, a, {:partial_parens, mult(tree)}}
  defp mult({:*, a, {:partial_parens, tree}}), do: {:*, a, {:partial_parens, mult(tree)}}
  defp mult(x), do: {:*, x, nil}

  def eval(n) when is_integer(n), do: n
  def eval({:+, a, b}), do: eval(a) + eval(b)
  def eval({:*, a, b}), do: eval(a) * eval(b)
  def eval({:parens, subtree}), do: eval(subtree)
end

File.read!("scratch.txt")
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
|> Stream.map(fn expr ->
  expr |> IO.inspect() |> NewMath.ast() |> IO.inspect() |> NewMath.eval()
end)
|> Enum.sum()
|> IO.inspect()
