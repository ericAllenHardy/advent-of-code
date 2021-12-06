defmodule Passport do
  def valid?(data), do: valid?(MapSet.new(["cid"]), data)

  defp valid?(passport, []),
    do: passport == MapSet.new(["ecl", "pid", "eyr", "hcl", "byr", "iyr", "cid", "hgt"])

  defp valid?(passport, [[key, value] | keys])
       when key in ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "cid", "hgt"] do
    valid_key?(key, value) and passport |> MapSet.put(key) |> valid?(keys)
  end

  defp valid_key?("ecl", ecl), do: ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  defp valid_key?("pid", pid), do: String.length(pid) == 9
  defp valid_key?("eyr", eyr), do: "2020" <= eyr and eyr <= "2030"
  defp valid_key?("hcl", hcl), do: Regex.match?(~r/#[0-9a-f]{6}/, hcl)
  defp valid_key?("byr", byr), do: "1920" <= byr and byr <= "2002"
  defp valid_key?("iyr", iyr), do: "2010" <= iyr and iyr <= "2020"
  defp valid_key?("cid", _cid), do: true

  defp valid_key?("hgt", hgt) do
    case String.split_at(hgt, -2) do
      {cm, "cm"} -> "150" <= cm and cm <= "193"
      {inch, "in"} -> "59" <= inch and inch <= "76"
      _ -> false
    end
  end
end

File.read!("input.txt")
|> String.split("\n\n")
|> Enum.map(fn s ->
  s
  |> String.split()
  |> Enum.map(fn kv -> String.split(kv, ":") end)
end)
|> Enum.filter(&Passport.valid?/1)
|> length()
|> IO.puts()
