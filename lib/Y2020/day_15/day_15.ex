defmodule Aoc.Y2020.Day15 do
  use Aoc.Day

  answers do
    part_1 536
    part_2 24_065_124
  end

  input do
    handle_input fn input ->
      input |> String.split(",") |> Enum.map(&String.to_integer/1)
    end
  end

  solutions do
    part_1 &count_up_to(&1, 2020)
    part_2 &count_up_to(&1, 30_000_000)
  end

  defp count_up_to(input, limit, tick \\ 1, last \\ nil, acc \\ %{})

  defp count_up_to([number], limit, tick, _last, acc) do
    count_up_to([], limit, tick + 1, number, acc)
  end

  defp count_up_to([number | rest], limit, tick, _last, acc) do
    count_up_to(rest, limit, tick + 1, number, Map.put(acc, number, tick))
  end

  defp count_up_to(_, limit, tick, last, _acc) when tick == limit + 1 do
    last
  end

  defp count_up_to([], limit, tick, last, acc) do
    num =
      case Map.get(acc, last) do
        nil ->
          0

        last_spoken ->
          tick - 1 - last_spoken
      end

    count_up_to([], limit, tick + 1, num, say(acc, last, tick - 1))
  end

  defp say(acc, num, value) do
    Map.put(acc, num, value)
  end
end
