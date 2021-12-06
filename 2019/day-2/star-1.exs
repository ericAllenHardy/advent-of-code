File.read!("input.txt")
|> IntCode.parse()
|> IntCode.run()
|> IO.inspect()
