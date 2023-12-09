defmodule Aoc.Y2023.Day9 do
  use Aoc.Day

  answers do
    part_1 1_930_746_032
    part_2 1154
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(&next_value/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(&next_value(&1, true))
      |> Enum.sum()
    end
  end

  defp next_value(sequence, reverse? \\ false, stack \\ nil)

  defp next_value(sequence, reverse?, stack) do
    stack =
      stack ||
        if reverse? do
          [List.first(sequence)]
        else
          [List.last(sequence)]
        end

    sequence
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce({[], true}, fn [l, r], {acc, all_zero?} ->
      val =
        if reverse? do
          l - r
        else
          r - l
        end

      case val do
        0 -> {[0 | acc], all_zero? && true}
        number -> {[number | acc], false}
      end
    end)
    |> case do
      {_acc, true} ->
        Enum.sum(stack)

      {[num | _] = list, _} when not reverse? ->
        next_value(Enum.reverse(list), reverse?, [num | stack])

      {list, _} when reverse? ->
        [num | _] = reversed = Enum.reverse(list)
        next_value(reversed, reverse?, [num | stack])
    end
  end
end
