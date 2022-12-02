defmodule Aoc.Y2020.Day6 do
  use Aoc.Day

  answers do
    part_1 6809
    part_2 3394
  end

  input do
    handle_input &String.split(&1, "\n\n")
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(fn group ->
        group
        |> String.graphemes()
        |> Enum.reject(&(&1 == "\n"))
        |> Enum.uniq()
        |> Enum.count()
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(fn group ->
        group
        |> String.split("\n")
        |> Enum.reduce(nil, fn row, intersection ->
          map_set = MapSet.new(String.graphemes(row))

          if intersection do
            MapSet.intersection(intersection, map_set)
          else
            map_set
          end
        end)
        |> MapSet.size()
      end)
      |> Enum.sum()
    end
  end
end
