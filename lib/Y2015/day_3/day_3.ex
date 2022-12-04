defmodule Aoc.Y2015.Day3 do
  use Aoc.Day

  answers do
    part_1 2565
  end

  input do
    handle_input fn input ->
      input
      |> String.graphemes()
      |> Enum.map(fn
        "^" -> :up
        "v" -> :down
        ">" -> :right
        "<" -> :left
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.reduce({%{}, {0, 0}}, fn direction, {acc, coords} ->
        {Map.update(acc, coords, 1, &(&1 + 1)), move(direction, coords)}
      end)
      |> then(fn {acc, coords} ->
        Map.update(acc, coords, 1, &(&1 + 1))
      end)
      |> Enum.count()
    end

    part_2 fn input ->
      input
      |> Stream.with_index()
      |> Enum.reduce({%{}, {0, 0}, {0, 0}}, fn {direction, index}, {acc, coords, robot} ->
        if rem(index, 2) == 0 do
          {Map.update(acc, coords, 1, &(&1 + 1)), move(direction, coords), robot}
        else
          {Map.update(acc, robot, 1, &(&1 + 1)), coords, move(direction, robot)}
        end
      end)
      |> then(fn {acc, coords, robot} ->
        acc
        |> Map.update(coords, 1, &(&1 + 1))
        |> Map.update(robot, 1, &(&1 + 1))
      end)
      |> Enum.count()
    end
  end

  defp move(:up, {x, y}), do: {x, y + 1}
  defp move(:down, {x, y}), do: {x, y - 1}
  defp move(:left, {x, y}), do: {x - 1, y}
  defp move(:right, {x, y}), do: {x + 1, y}
end
