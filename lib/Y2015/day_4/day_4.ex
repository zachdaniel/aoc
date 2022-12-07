defmodule Aoc.Y2015.Day4 do
  use Aoc.Day

  answers do
    part_1 282_749
  end

  input do
    handle_input fn input ->
      input
    end
  end

  solutions do
    part_1 fn input ->
      find_hash(input)
    end

    part_2 fn input ->
      find_hash(input, "000000")
    end
  end

  defp find_hash(input, leader \\ "00000", n \\ 0) do
    "#{input}#{n}"
    |> :erlang.md5()
    |> Base.encode16()
    |> String.starts_with?(leader)
    |> case do
      true ->
        n

      false ->
        find_hash(input, leader, n + 1)
    end
  end
end
