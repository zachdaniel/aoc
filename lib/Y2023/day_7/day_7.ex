defmodule Aoc.Y2023.Day7 do
  use Aoc.Day

  answers do
    part_1 248_453_531
    part_2 248_781_813
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        [hand, bid] =
          String.split(line, " ")

        %{hand: String.split(hand, "", trim: true), bid: String.to_integer(bid)}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.sort_by(&rank/1, :asc)
      |> Stream.with_index()
      |> Enum.map(fn {%{bid: bid}, index} ->
        bid * (index + 1)
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.sort_by(&rank(&1, true), :asc)
      |> Stream.with_index()
      |> Enum.map(fn {%{bid: bid}, index} ->
        bid * (index + 1)
      end)
      |> Enum.sum()
    end
  end

  defp rank(%{hand: hand}, part_2? \\ false) do
    {hand_rank(hand, part_2?), tie_breaker(hand, part_2?)}
  end

  defp hand_rank(hand, true) do
    frequencies =
      hand
      |> Enum.frequencies()

    num_js = frequencies |> Map.get("J", 0)

    frequencies =
      frequencies
      |> Map.values()
      |> Enum.sort()

    cond do
      frequencies == [5] -> 7
      frequencies == [1, 4] && num_js in [1, 4] -> 7
      frequencies == [1, 4] -> 6
      frequencies == [2, 3] && num_js in [2, 3] -> 7
      frequencies == [2, 3] -> 5
      frequencies == [1, 1, 3] && num_js in [3, 1] -> 6
      frequencies == [1, 1, 3] -> 4
      frequencies == [1, 2, 2] && num_js == 2 -> 6
      frequencies == [1, 2, 2] && num_js == 1 -> 5
      frequencies == [1, 2, 2] -> 3
      frequencies == [1, 1, 1, 2] && num_js in [2, 1] -> 4
      frequencies == [1, 1, 1, 2] -> 2
      frequencies == [1, 1, 1, 1, 1] && num_js == 1 -> 2
      frequencies == [1, 1, 1, 1, 1] -> 1
    end
  end

  defp hand_rank(hand, _part_2?) do
    frequencies =
      hand
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort()

    cond do
      frequencies == [5] -> 7
      frequencies == [1, 4] -> 6
      frequencies == [2, 3] -> 5
      frequencies == [1, 1, 3] -> 4
      frequencies == [1, 2, 2] -> 3
      frequencies == [1, 1, 1, 2] -> 2
      true -> 1
    end
  end

  defp tie_breaker(hand, part_2?) do
    Enum.map(hand, fn
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" when part_2? -> 1
      "J" -> 11
      "T" -> 10
      number -> String.to_integer(number)
    end)
  end
end
