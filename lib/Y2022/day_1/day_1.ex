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
end
