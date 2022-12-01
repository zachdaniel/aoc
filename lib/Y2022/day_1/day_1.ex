defmodule Aoc.Y2022.Day1 do
  use Aoc.Day

  answers do
    part_1 69206
    part_2 197_400
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))
      |> Enum.map(fn elf ->
        Enum.map(elf, &String.to_integer/1)
      end)
    end
  end

  solutions do
    part_1 fn elves ->
      elves
      |> Enum.map(&Enum.sum/1)
      |> Enum.max()
    end

    part_2 fn elves ->
      elves
      |> Enum.map(&Enum.sum/1)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(3)
      |> Enum.sum()
    end
  end
end
