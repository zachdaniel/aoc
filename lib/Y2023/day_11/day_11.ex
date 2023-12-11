defmodule Aoc.Y2023.Day11 do
  use Aoc.Day

  answers do
    part_1 9_609_130
    part_2 702_152_204_842
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> build_grid()
      |> expand()
    end

    handle_part_2_input fn input ->
      input
      |> build_grid()
      |> expand(1_000_000)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> unique_pairs()
      |> Enum.map(&distance/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> unique_pairs()
      |> Enum.map(&distance/1)
      |> Enum.sum()
    end
  end

  defp unique_pairs(input) do
    for point <- input, other_point <- input, point != other_point do
      [point, other_point]
    end
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
  end

  defp build_grid(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {line, y}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {"#", x}, acc ->
          MapSet.put(acc, {x, -y})

        _, acc ->
          acc
      end)
    end)
  end

  defp expand(grid, factor \\ 2) do
    min_y = grid |> Enum.map(&elem(&1, 1)) |> Enum.min()
    max_x = grid |> Enum.map(&elem(&1, 0)) |> Enum.max()

    cols_expanding =
      Enum.reject(0..max_x, fn x ->
        min_y..0
        |> Enum.any?(fn y ->
          {x, y} in grid
        end)
      end)

    rows_expanding =
      Enum.reject(min_y..0, fn y ->
        0..max_x
        |> Enum.any?(fn x ->
          {x, y} in grid
        end)
      end)

    MapSet.new(grid, fn {x, y} ->
      {x + Enum.count(cols_expanding, &(&1 < x)) * (factor - 1),
       y - Enum.count(rows_expanding, &(&1 > y)) * (factor - 1)}
    end)
  end

  defp distance([{x1, y1}, {x2, y2}]) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
