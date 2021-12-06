defmodule PasswordValidator do
  def validate(s) do
    %{"char" => c, "min_count" => min, "max_count" => max, "password" => password} =
      Regex.named_captures(
        ~r/(?<min_count>[0-9]+)-(?<max_count>[0-9]+) (?<char>[a-zA-Z]): (?<password>[a-zA-Z]+)/,
        s
      )

    count = password |> String.graphemes() |> Enum.count(&(&1 == c))
    count >= String.to_integer(min) && count <= String.to_integer(max)
  end
end

File.read!('input.txt')
|> String.split("\n")
|> Enum.filter(&PasswordValidator.validate/1)
|> length()
|> IO.inspect()
