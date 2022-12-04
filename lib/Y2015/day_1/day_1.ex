defmodule Aoc.Y2015.Day1 do
  use Aoc.Day

  answers do
    part_1 138
    part_2 1771
  end

  input do
    handle_input fn input ->
      String.graphemes(input)
    end
  end

  solutions do
    part_1 fn input ->
      Enum.count(input, &(&1 == "(")) - Enum.count(input, &(&1 == ")"))
    end

    part_2 fn input ->
      Enum.reduce(Enum.with_index(input), {0, false}, fn
        {char, _index}, {acc, false} when acc >= 0 ->
          if char == "(" do
            {acc + 1, false}
          else
            {acc - 1, false}
          end

        {_char, index}, {-1, false} ->
          {index, true}

        _, acc ->
          acc
      end)
      |> elem(0)
    end
  end
end
