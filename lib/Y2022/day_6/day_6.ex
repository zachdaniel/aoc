defmodule Aoc.Y2022.Day6 do
  use Aoc.Day

  answers do
    part_1 1896
    part_2 3452
  end

  input do
    handle_input fn input ->
      input
      |> String.graphemes()
    end
  end

  solutions do
    part_1 fn input ->
      find_four_different(input)
    end

    part_2 fn input ->
      find_four_different(input, 14)
    end
  end

  defp find_four_different([_|rest] = input, required \\ 4, n \\ 0) do
    taken = Enum.take(input, required)
    if taken == Enum.uniq(taken) do
      n + required
    else
      find_four_different(rest, required, n + 1)
    end

  end
end
