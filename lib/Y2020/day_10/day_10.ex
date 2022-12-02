defmodule Aoc.Y2020.Day10 do
  use Aoc.Day

  answers do
    part_1 2400
    part_2 338_510_590_509_056
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.reduce({%{1 => 0, 2 => 0, 3 => 1}, 0}, fn item, {acc, last} ->
        {Map.update!(acc, item - last, &(&1 + 1)), item}
      end)
      |> elem(0)
      |> Map.take([1, 3])
      |> Map.values()
      |> Enum.reduce(&Kernel.*/2)
    end

    part_2 fn input ->
      [0 | input]
      |> count_possibilities()
    end
  end

  defp count_possibilities([_]), do: 1

  defp count_possibilities([first | rest]) do
    # Many possibilities don't appear in the puzzle input, so I've removed them from
    # the case statement for clarity
    case Enum.count(Enum.take_while(rest, &(&1 - first <= 3))) do
      1 ->
        count_possibilities(rest)

      2 ->
        count_possibilities(Enum.drop(rest, 1)) * 2

      3 ->
        case Enum.at(rest, 3) do
          val when val == first + 4 ->
            count_possibilities(Enum.drop(rest, 2)) * 7

          val when val == first + 6 ->
            count_possibilities(Enum.drop(rest, 2)) * 4
        end
    end
  end
end
