defmodule Aoc.Y2023.Day16 do
  use Aoc.Day

  answers do
    part_1 8146
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> string_to_grid(with_size?: true)
    end
  end

  solutions do
    part_1 fn input ->
      input.grid
      |> move_fully([{make_ref(), {-1, 0}, :right}])
      |> Enum.count()
    end

    part_2 fn input ->
      xs =
        Enum.flat_map(input.bounds.x.min..input.bounds.x.max, fn x ->
          [
            {make_ref(), {x, input.bounds.y.min - 1}, :up},
            {make_ref(), {x, input.bounds.y.max - 1}, :down}
          ]
        end)

      ys =
        Enum.flat_map(input.bounds.y.min..input.bounds.y.max, fn y ->
          [
            {make_ref(), {input.bounds.x.min - 1, y}, :right},
            {make_ref(), {input.bounds.x.max + 1, y}, :left}
          ]
        end)

      xs
      |> Enum.concat(ys)
      |> Enum.map(&move_fully(input.grid, [&1]))
      |> Enum.map(&Enum.count/1)
      |> Enum.max()
    end
  end

  defp move_fully(grid, points, acc \\ %{})
  defp move_fully(_grid, [], acc), do: acc

  defp move_fully(grid, points, acc) do
    points
    |> Enum.reduce({acc, []}, fn {ref, {x, y}, direction}, {acc, new_points} ->
      new_position =
        case direction do
          :left ->
            {x - 1, y}

          :right ->
            {x + 1, y}

          :up ->
            {x, y + 1}

          :down ->
            {x, y - 1}
        end

      if {ref, direction} in Map.get(acc, {x, y}, []) do
        {acc, new_points}
      else
        acc =
          if Map.get(grid, {x, y}) do
            acc
            |> Map.put_new_lazy({x, y}, fn -> MapSet.new() end)
            |> Map.update!({x, y}, &MapSet.put(&1, {ref, direction}))
          else
            acc
          end

        case {direction, Map.get(grid, new_position)} do
          {_, nil} ->
            {acc, new_points}

          {sideways, "|"} when sideways in [:left, :right] ->
            {acc, [{ref, new_position, :up}, {ref, new_position, :down} | new_points]}

          {vertical, "-"} when vertical in [:up, :down] ->
            {acc, [{ref, new_position, :left}, {ref, new_position, :right} | new_points]}

          {:left, "/"} ->
            {acc, [{ref, new_position, :down} | new_points]}

          {:right, "/"} ->
            {acc, [{ref, new_position, :up} | new_points]}

          {:down, "/"} ->
            {acc, [{ref, new_position, :left} | new_points]}

          {:up, "/"} ->
            {acc, [{ref, new_position, :right} | new_points]}

          {:left, "\\"} ->
            {acc, [{ref, new_position, :up} | new_points]}

          {:right, "\\"} ->
            {acc, [{ref, new_position, :down} | new_points]}

          {:down, "\\"} ->
            {acc, [{ref, new_position, :right} | new_points]}

          {:up, "\\"} ->
            {acc, [{ref, new_position, :left} | new_points]}

          {direction, _} ->
            {acc, [{ref, new_position, direction} | new_points]}
        end
      end
    end)
    |> then(fn {acc, new_points} ->
      move_fully(grid, new_points, acc)
    end)
  end
end
