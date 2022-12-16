defmodule Aoc.Y2022.Day15 do
  use Aoc.Day

  answers do
    part_1 5_525_847
    part_2 13_340_867_187_704
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn "Sensor at x=" <> rest ->
        {x, rest} = Integer.parse(rest)
        ", y=" <> rest = rest
        {y, rest} = Integer.parse(rest)
        ": closest beacon is at x=" <> rest = rest
        {beacon_x, rest} = Integer.parse(rest)
        ", y=" <> rest = rest
        {beacon_y, _} = Integer.parse(rest)

        %{sensor: {x, y}, beacon: {beacon_x, beacon_y}}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> find_taken_positions_at_row(2_000_000)
    end

    part_2 fn input ->
      limit = 4_000_000

      {x, y} =
        0..limit
        |> Enum.find_value(fn line ->
          Enum.flat_map(input, fn item ->
            range_at_line(item, line)
          end)
          |> Enum.sort_by(fn range ->
            range.first
          end)
          |> case do
            [left..right] ->
              cond do
                left > 0 ->
                  {left, line}

                left < limit ->
                  {right, line}

                true ->
                  nil
              end

            ranges ->
              ranges
              |> Enum.reduce_while(nil, fn
                this_range, nil ->
                  {:cont, this_range}

                next, previous ->
                  cond do
                    range_inside?(previous, next) ->
                      {:cont, previous}

                    next.first - previous.last > 1 ->
                      {:halt, {:answer, {previous.last + 1, line}}}

                    true ->
                      {:cont, next}
                  end
              end)
              |> case do
                {:answer, {left, right}}
                when left >= 0 and left <= limit and right >= 0 and right <= limit ->
                  {left, right}

                _ ->
                  nil
              end
          end
        end)

      x * 4_000_000 + y
    end
  end

  defp range_inside?(left_left..left_right, right_left..right_right) do
    right_left >= left_left and left_right >= right_right
  end

  defp range_at_line(%{sensor: {x, y} = sensor, beacon: beacon}, n) do
    distance = manhattan_distance(sensor, beacon)
    top_range = y + distance
    bottom_range = y - distance

    if n <= top_range and n >= bottom_range do
      distance = abs(distance - abs(y - n))

      [(x - distance)..(x + distance)]
    else
      []
    end
  end

  defp find_taken_positions_at_row(input, n) do
    input
    |> Enum.flat_map(&taken_spots_in_row(&1, n))
    |> Enum.uniq()
    |> Kernel.--(Enum.flat_map(input, &[&1.sensor, &1.beacon]))
    |> Enum.count()
  end

  defp taken_spots_in_row(%{sensor: {x, y} = sensor, beacon: beacon}, n) do
    distance = manhattan_distance(sensor, beacon)
    top_range = y + distance
    bottom_range = y - distance

    if n <= top_range and n >= bottom_range do
      distance = abs(distance - abs(y - n))

      (x - distance)..(x + distance)
      |> Enum.map(fn x ->
        {x, n}
      end)
    else
      []
    end
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
