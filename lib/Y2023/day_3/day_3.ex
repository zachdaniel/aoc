defmodule Aoc.Y2023.Day3 do
  use Aoc.Day

  answers do
    part_1 550_064
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, acc ->
          Map.put(acc, {x, y}, char)
        end)
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.filter(fn {key, value} ->
        is_symbol?(value)
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.flat_map(&adjacent_points/1)
      |> Enum.filter(&Map.has_key?(input, &1))
      |> Enum.map(&get_number_with_coords(&1, input))
      |> Enum.reject(&is_nil/1)
      |> Enum.map(fn {key, list} ->
        {key, list |> Enum.sort() |> Enum.uniq()}
      end)
      |> Enum.uniq_by(&elem(&1, 1))
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.filter(fn {key, value} ->
        is_gear?(value)
      end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(fn coords ->
        coords
        |> adjacent_points()
        |> Enum.filter(&Map.has_key?(input, &1))
        |> Enum.map(&get_number_with_coords(&1, input))
        |> Enum.reject(&is_nil/1)
        |> Enum.map(fn {key, list} ->
          {key, list |> Enum.sort() |> Enum.uniq()}
        end)
        |> Enum.uniq_by(&elem(&1, 1))
        |> Enum.map(&elem(&1, 0))
        |> Enum.map(&String.to_integer/1)
        |> case do
          [x, y] ->
            x * y

          _ ->
            0
        end
      end)
      |> Enum.sum()
    end
  end

  defp get_number_with_coords(point, grid) do
    if is_symbol?(grid[point]) || grid[point] == "." do
      nil
    else
      case get_full_number(grid, point) do
        {_, ""} ->
          nil

        {coords, number} ->
          {number, coords}
      end
    end
  end

  defp get_full_number(grid, {x, y}, only_direction \\ nil) do
    number? = is_number?(grid[{x, y}])

    {new_coords, left} =
      if number? && (is_nil(only_direction) || only_direction == :left) do
        get_full_number(grid, {x - 1, y}, :left)
      else
        {[], ""}
      end

    {new_right_coords, right} =
      if number? && (is_nil(only_direction) || only_direction == :right) do
        get_full_number(grid, {x + 1, y}, :right)
      else
        {[], ""}
      end

    coords = [{x, y}] ++ new_coords ++ new_right_coords

    if number? do
      {coords, left <> grid[{x, y}] <> right}
    else
      {[], ""}
    end
  end

  defp adjacent_points({x, y}) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
  end

  defp is_gear?(char) do
    # not is a number or a dot
    char == "*"
  end

  defp is_symbol?(char) do
    # not is a number or a dot
    char not in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
  end

  defp is_number?(char) do
    # not is a number or a dot
    char in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end
end
