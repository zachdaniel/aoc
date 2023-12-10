defmodule Aoc.Y2022.Day17 do
  use Aoc.Day

  answers do
    part_1 3179
  end

  input do
    use_example? true

    handle_input fn input ->
      air = {String.split(input, "", trim: true), []}
      rocks = {[:horizontal_line, :cross, :right_angle, :vertical_line, :square], []}

      %{air: air, rocks: rocks, height: 0, tower: %{}, cache: %{}}
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> drop_rocks(2022)
      |> Map.get(:height)
    end

    part_2 fn input ->
      cycles_at = find_cycle(input)

      # input
      # |> drop_rocks(1000000000000)
      # |> Map.get(:height)
    end
  end

  defp find_cycle(input, n \\ 0)

  defp find_cycle(input, n) do
    if n >= 20 do
      # top_20_offset = top_10_offset(input)

      if Enum.all?(0..6, &input.tower[{&1, input.height - 1}]) do
        raise n
      else
        input
        |> drop_rock()
        |> find_cycle(n + 1)
      end
    else
      input
      |> drop_rock()
      |> find_cycle(n + 1)
    end
  end

  # defp top_10_offset(input) do
  #   (input.height - 1)..(input.height - 11)
  # end

  defp drop_rocks(input, 0), do: input

  defp drop_rocks(input, n) do
    input
    |> drop_rock()
    |> drop_rocks(n - 1)
  end

  # defp print(input) do
  #   input.height..0
  #   |> Enum.map_join("\n", fn y ->
  #     0..6
  #     |> Enum.map_join(fn x ->
  #       if input.tower[{x, y}] do
  #         "#"
  #       else
  #         "."
  #       end
  #     end)
  #   end)
  #   |> Kernel.<>("\n===\n")
  #   |> IO.puts()

  #   input
  # end

  defp drop_rock(input) do
    {rock, input} = get_and_cycle(input, :rocks)
    {input, coords} = place_new_rock(input, rock)
    move_rock_until_stopped(input, coords, rock)
  end

  defp move_rock_until_stopped(input, coords, rock) do
    {input, coords} = try_blow(input, coords, rock)

    case move_down(input, coords, rock) do
      :resting ->
        set_height(input, rock_coords(coords, rock))

      {input, coords} ->
        move_rock_until_stopped(input, coords, rock)
    end
  end

  defp move_coord({x, y}, ">"), do: {x + 1, y}
  defp move_coord({x, y}, "<"), do: {x - 1, y}

  defp move_down(input, {x, y} = coords, rock) do
    current_coords = rock_coords(coords, rock)

    new_coords =
      Enum.map(current_coords, fn {x, y} ->
        {x, y - 1}
      end)

    input_without = input |> delete_rocks(current_coords)

    if Enum.any?(new_coords, fn {x, y} -> input_without.tower[{x, y}] || y == -1 end) do
      :resting
    else
      {input_without |> set_rocks(new_coords), {x, y - 1}}
    end
  end

  defp try_blow(input, coords, rock) do
    {direction, input} = get_and_cycle(input, :air)
    current_rock_coords = rock_coords(coords, rock)

    new_rock_coords = Enum.map(current_rock_coords, &move_coord(&1, direction))
    input_without = input |> delete_rocks(current_rock_coords)

    if Enum.any?(new_rock_coords, fn {x, _y} = coord ->
         input_without.tower[coord] || x < 0 || x > 6
       end) do
      {input, coords}
    else
      {input_without |> set_rocks(new_rock_coords), move_coord(coords, direction)}
    end
  end

  defp delete_rocks(input, coords) do
    Map.update!(input, :tower, fn tower ->
      Map.drop(tower, coords)
    end)
  end

  defp place_new_rock(input, rock) do
    bottom_y = input.height + 3
    left_x = 2

    coords = rock_coords({left_x, bottom_y}, rock)

    {set_rocks(input, coords), {left_x, bottom_y}}
  end

  defp set_height(input, coords) do
    height =
      coords
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    Map.update!(input, :height, &max(&1, height + 1))
  end

  defp rock_coords({x, y}, :horizontal_line) do
    [{x, y}, {x + 1, y}, {x + 2, y}, {x + 3, y}]
  end

  defp rock_coords({x, y}, :cross) do
    [{x, y + 1}, {x + 1, y + 1}, {x + 1, y + 2}, {x + 1, y}, {x + 2, y + 1}]
  end

  defp rock_coords({x, y}, :right_angle) do
    [{x, y}, {x + 1, y}, {x + 2, y}, {x + 2, y + 1}, {x + 2, y + 2}]
  end

  defp rock_coords({x, y}, :vertical_line) do
    [{x, y}, {x, y + 1}, {x, y + 2}, {x, y + 3}]
  end

  defp rock_coords({x, y}, :square) do
    [{x, y}, {x, y + 1}, {x + 1, y}, {x + 1, y + 1}]
  end

  defp set_rocks(input, coords), do: Enum.reduce(coords, input, &set_rock(&2, &1))

  defp set_rock(input, {x, y}) do
    Map.update!(input, :tower, &Map.put(&1, {x, y}, "#"))
  end

  defp get_and_cycle(map, key) do
    case Map.get(map, key) do
      {[], cycle} ->
        [first | rest] = Enum.reverse(cycle)

        {first, Map.put(map, key, {rest, [first]})}

      {[next | rest], cycle} ->
        {next, Map.put(map, key, {rest, [next | cycle]})}
    end
  end
end
