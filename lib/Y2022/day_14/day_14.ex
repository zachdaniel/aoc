defmodule Aoc.Y2022.Day14 do
  use Aoc.Day

  answers do
    part_1 961
    part_2 26375
  end

  input do
    handle_input fn input ->
      acc =
        input
        |> String.split("\n")
        |> Enum.reduce(%{}, fn path, acc ->
          path
          |> String.split(" -> ")
          |> Enum.map(fn coord ->
            [x, y] = String.split(coord, ",")
            {String.to_integer(x), String.to_integer(y)}
          end)
          |> Enum.reduce({acc, nil}, fn
            point, {acc, nil} ->
              {acc, point}

            point, {acc, last_point} ->
              new_acc =
                Enum.reduce(points_between(last_point, point), acc, fn point, acc ->
                  Map.put(acc, point, :rock)
                end)

              {new_acc, point}
          end)
          |> elem(0)
        end)

      max_rock =
        acc
        |> Map.keys()
        |> Enum.map(&elem(&1, 1))
        |> Enum.max()

      xs = acc |> Map.keys() |> Enum.map(&elem(&1, 0))
      min_x = Enum.min(xs)
      max_x = Enum.max(xs)

      %{acc: acc, max_rock: max_rock, min_x: min_x, max_x: max_x}
    end
  end

  solutions do
    part_1 fn input ->
      tick_until_falling_off(input.acc, input.max_rock, input.min_x, input.max_x)
    end

    part_2 fn input ->
      tick_until_falling_off(input.acc, input.max_rock, input.min_x, input.max_x, input.max_rock + 2)
      |> Kernel.+(1)
    end
  end

  defp tick_until_falling_off(acc, max, min_x, max_x, floor \\ nil, tick \\ 0) do
    acc
    |> add_sand(max, floor)
    |> case do
      :infinite ->
        # print_board(acc, max, floor)
        tick

      {:ok, acc} ->
        tick_until_falling_off(acc, max, min_x, max_x, floor, tick + 1)
    end
  end

  # defp print_board(points, max_y, floor) do
  #   xs = points |> Map.keys() |> Enum.map(&elem(&1, 0))
  #   min_x = Enum.min(xs)
  #   max_x = Enum.max(xs)

  #   0..(floor || max_y)
  #   |> Enum.map_join("\n", fn y ->
  #     "#{y}" <> Enum.map_join(min_x..max_x, fn x ->
  #       case Map.get(points, {x, y}) do
  #         :rock ->
  #           "#"
  #         :sand ->
  #           "o"
  #         nil ->
  #           "."
  #       end
  #     end)
  #   end)
  #   |> IO.puts()

  #   points
  # end

  defp add_sand(acc, max, floor) do
    sand_pos = {500, 0}

    case move_sand(Map.put(acc, sand_pos, :sand), sand_pos, max, floor) do
      {:ok, acc} ->
        {:ok, acc}

      :infinite ->
        :infinite
    end
  end

  defp move_sand(acc, sand_pos, max, floor) do
    case move_sand_once(acc, sand_pos, max, floor) do
      {:ok, acc, sand_pos} ->
        move_sand(acc, sand_pos, max, floor)

      :stopped when sand_pos == {500, 0} ->
        :infinite

      :stopped ->
        {:ok, acc}

      :infinite ->
        :infinite
    end
  end

  defp move_sand_once(acc, sand_pos, max, floor) do
    case next_pos(acc, sand_pos, max, floor) do
      :stopped ->
        :stopped

      {:next, pos} ->
        {:ok, acc |> Map.delete(sand_pos) |> Map.put(pos, :sand), pos}

      :infinite ->
        :infinite
    end
  end

  defp next_pos(acc, {x, y}, max, floor) do
    case straight_down(acc, {x, y}) || down_left(acc, {x, y}) || down_right(acc, {x, y}) do
      {_x, ^max} when is_nil(floor) ->
        :infinite

      {_, ^floor} ->
        :stopped


      nil ->
        :stopped

      point ->
        {:next, point}
    end
  end

  defp straight_down(acc, {x, y}) do
    straight_down = {x, y + 1}

    case Map.get(acc, straight_down) do
      nil ->
        straight_down

      _ ->
        nil
    end
  end

  defp down_left(acc, {x, y}) do
    down_left = {x - 1, y + 1}

    case Map.get(acc, down_left) do
      nil ->
        down_left

      _ ->
        nil
    end
  end

  defp down_right(acc, {x, y}) do
    down_right = {x + 1, y + 1}

    case Map.get(acc, down_right) do
      nil ->
        down_right

      _ ->
        nil
    end
  end

  defp points_between({left_x, left_y}, {left_x, right_y}) do
    left_y..right_y |> Enum.map(&{left_x, &1})
  end

  defp points_between({left_x, left_y}, {right_x, left_y}) do
    left_x..right_x |> Enum.map(&{&1, left_y})
  end
end
