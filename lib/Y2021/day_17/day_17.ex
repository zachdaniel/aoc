defmodule Aoc.Y2021.Day17 do
  use Aoc.Day

  input do
    handle_input fn input ->
      input = String.trim_leading(input, "target area: ")

      [x_range, y_range] = String.split(input, ", ")

      %{
        x_range: parse_range(x_range),
        y_range: parse_range(y_range)
      }
    end
  end

  solutions do
    part_1 &find_highest_possible_y/1
    part_2 &find_all_possible_initial_values/1
  end

  defp parse_range(range) do
    [start, finish] =
      range
      |> String.trim_leading("x=")
      |> String.trim_leading("y=")
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort_by(&abs/1)

    start..finish
  end

  defp find_all_possible_initial_values(target_area, current_y \\ nil, values \\ []) do
    current_y = current_y || target_area.y_range.last

    if current_y > abs(target_area.y_range.last) + 1 do
      Enum.count(values)
    else
      new_values = values ++ find_all_xs_that_intersect_target_area(target_area, current_y)
      find_all_possible_initial_values(target_area, current_y + 1, new_values)
    end
  end

  defp find_highest_possible_y(target_area, current_y \\ 1, winning_y \\ 0) do
    if current_y > abs(target_area.y_range.last) + 1 do
      get_highest_distance(winning_y)
    else
      if does_intersect_target_area?(target_area, current_y) do
        find_highest_possible_y(target_area, current_y + 1, current_y)
      else
        find_highest_possible_y(target_area, current_y + 1, winning_y)
      end
    end
  end

  defp get_highest_distance(winning_y) do
    sum_of_all_integers_below(winning_y + 1)
  end

  defp find_all_xs_that_intersect_target_area(target_area, y, current_x \\ 1, values \\ []) do
    if current_x > target_area.x_range.last do
      values
    else
      if any_step_intersects_target_area?(target_area, y, current_x) do
        new_values = [{current_x, y} | values]
        find_all_xs_that_intersect_target_area(target_area, y, current_x + 1, new_values)
      else
        find_all_xs_that_intersect_target_area(target_area, y, current_x + 1, values)
      end
    end
  end

  defp does_intersect_target_area?(
         target_area,
         y,
         current_x \\ 1
       ) do
    if current_x > target_area.x_range.last do
      false
    else
      if any_step_intersects_target_area?(target_area, y, current_x) do
        true
      else
        does_intersect_target_area?(target_area, y, current_x + 1)
      end
    end
  end

  def any_step_intersects_target_area?(
        target_area,
        y,
        x,
        current_step \\ 1,
        last_seen_point \\ {0, 0}
      ) do
    point_at_step = point_at_step(current_step, x, y)

    if point_in_target_area?(point_at_step, target_area) do
      true
    else
      if point_could_have_intersected_target_area?(point_at_step, target_area, last_seen_point) do
        false
      else
        if will_never_hit_target?(point_at_step, last_seen_point, target_area) do
          false
        else
          any_step_intersects_target_area?(target_area, y, x, current_step + 1, point_at_step)
        end
      end
    end
  end

  defp will_never_hit_target?({point_x, point_y}, {point_x, _}, target_area) do
    point_y < target_area.y_range.last
  end

  defp will_never_hit_target?(_, _, _) do
    false
  end

  defp point_could_have_intersected_target_area?(
         {point_x, point_y},
         target_area,
         {last_point_x, last_point_y}
       ) do
    last_point_x < target_area.x_range.last &&
      last_point_y > target_area.y_range.last &&
      point_y < target_area.y_range.first && point_x > target_area.x_range.first
  end

  defp point_in_target_area?({x, y}, %{x_range: x_range, y_range: y_range}) do
    x in x_range && y in y_range
  end

  defp point_at_step(step_number, x_velocity, y_velocity) do
    x =
      if step_number > x_velocity do
        sum_of_all_integers_below(x_velocity + 1)
      else
        sum_of_all_integers_below(x_velocity + 1) -
          sum_of_all_integers_below(x_velocity + 1 - step_number)
      end

    y =
      sum_of_all_integers_below(y_velocity + 1) -
        sum_of_all_integers_below(y_velocity + 1 - step_number)

    {x, y}
  end

  def sum_of_all_integers_below(n) do
    div(n * (n - 1), 2)
  end
end
