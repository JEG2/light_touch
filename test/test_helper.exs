"support/*.exs"
|> Path.expand(__DIR__)
|> Path.wildcard()
|> Enum.each(&Code.require_file/1)

ExUnit.start()
