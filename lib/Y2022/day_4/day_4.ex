defmodule Aoc.Y2022.Day4 do
  use Aoc.Day

  answers do
    part_1 496
    part_2 847
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(fn elf ->
          elf
          |> String.split("-")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)
        |> List.to_tuple()
      end)
    end
  end

  solutions do
    part_1 fn input ->
      Enum.count(input, fn {{left_first, left_last}, {right_first, right_last}} ->
        (left_first <= right_first and left_last >= right_last) ||
          (right_first <= left_first and right_last >= left_last)
      end)
    end

    part_2 fn input ->
      Enum.count(input, fn {{left_first, left_last}, {right_first, right_last}} ->
        (left_first <= right_first and left_last >= right_first) ||
          (right_first <= left_first and right_last >= left_first)
      end)
    end
  end
end
