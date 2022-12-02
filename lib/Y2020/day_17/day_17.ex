defmodule Aoc.Y2020.Day17 do
  use Aoc.Day

  answers do
    part_1 289
    part_2 2084
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn {row, row_num}, acc ->
        row
        |> String.split("")
        |> Enum.reject(&(&1 == ""))
        |> Enum.with_index()
        |> Enum.reduce(acc, fn
          {".", _}, acc ->
            acc

          {_, col_num}, acc ->
            MapSet.put(acc, {row_num, col_num, 0})
        end)
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> tick(6, 3)
      |> MapSet.size()
    end

    part_2 fn input ->
      input
      |> MapSet.new(fn {x, y, z} -> {x, y, z, 0} end)
      |> tick(6, 4)
      |> MapSet.size()
    end
  end

  defp tick(input, 0, _), do: input

  defp tick(input, times, dimensions) do
    input_deactivated =
      Enum.reduce(input, MapSet.new(), fn coords, acc ->
        if two_or_three_neighbors_active?(input, coords, dimensions) do
          MapSet.put(acc, coords)
        else
          acc
        end
      end)

    new_input =
      input
      |> Enum.flat_map(fn coords ->
        neighbors(coords, dimensions)
      end)
      |> Enum.reject(&MapSet.member?(input, &1))
      |> Enum.reduce(%{}, fn coords, acc ->
        Map.update(acc, coords, 1, &(&1 + 1))
      end)
      |> Enum.filter(fn
        {_, 3} ->
          true

        _ ->
          false
      end)
      |> Enum.reduce(input_deactivated, fn {coords, _}, acc ->
        MapSet.put(acc, coords)
      end)

    tick(new_input, times - 1, dimensions)
  end

  defp two_or_three_neighbors_active?(input, coords, dimensions) do
    coords
    |> neighbors(dimensions)
    |> Enum.count(&MapSet.member?(input, &1))
    |> Kernel.in([2, 3])
  end

  @three_dimension_diffs (for x <- [-1, 0, 1], y <- [-1, 0, 1], z <- [-1, 0, 1] do
                            {x, y, z}
                          end)
                         |> Enum.reject(&(&1 == {0, 0, 0}))

  @four_dimension_diffs (for x <- [-1, 0, 1], y <- [-1, 0, 1], z <- [-1, 0, 1], w <- [-1, 0, 1] do
                           {x, y, z, w}
                         end)
                        |> Enum.reject(&(&1 == {0, 0, 0, 0}))

  def neighbors({x, y, z}, 3) do
    for {xd, yd, zd} <- @three_dimension_diffs do
      {x + xd, y + yd, z + zd}
    end
  end

  def neighbors({x, y, z, w}, 4) do
    for {xd, yd, zd, wd} <- @four_dimension_diffs do
      {x + xd, y + yd, z + zd, w + wd}
    end
  end
end
