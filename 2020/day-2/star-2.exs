defmodule PasswordValidator do
  def validate(s) do
    %{"char" => c, "min_count" => posn1, "max_count" => posn2, "password" => password} =
      Regex.named_captures(
        ~r/(?<min_count>[0-9]+)-(?<max_count>[0-9]+) (?<char>[a-zA-Z]): (?<password>[a-zA-Z]+)/,
        s |> IO.inspect(label: "line")
      )
      |> IO.inspect(label: "parsed")

    char_at_1 = String.at(password, String.to_integer(posn1) - 1)
    char_at_2 = String.at(password, String.to_integer(posn2) - 1)

    ((char_at_1 == c or char_at_2 == c) and char_at_1 != char_at_2) |> IO.inspect(label: "result")
  end
end

File.read!('input.txt')
|> String.split("\n")
|> Enum.filter(&PasswordValidator.validate/1)
|> length()
|> IO.inspect()
