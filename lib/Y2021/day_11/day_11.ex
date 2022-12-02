defmodule Aoc.Y2021.Day11 do
  use Aoc.Day

  answers do
    part_1 1743
    part_2 364
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {octopus_energy_value, x}, acc ->
          Map.put(acc, {x, y}, String.to_integer(octopus_energy_value))
        end)
      end)
    end
  end

  solutions do
    part_1 &run_steps(&1, 100)
    part_2 &find_synchronized_step(&1, Enum.count(&1))
  end

  defp find_synchronized_step(octopuses, input_size, step \\ 0)

  defp find_synchronized_step(octopuses, input_size, step) do
    {new_octopuses, count_of_flashes} =
      octopuses
      |> increase_all()
      |> count_and_reset_flashed_octopuses()

    if count_of_flashes == input_size do
      step + 1
    else
      find_synchronized_step(new_octopuses, input_size, step + 1)
    end
  end

  defp run_steps(octopuses, steps, total_flashes \\ 0)
  defp run_steps(_octopuses, 0, total_flashes), do: total_flashes

  defp run_steps(octopuses, steps, total_flashes) do
    {new_octopuses, count_of_flashes} =
      octopuses
      |> increase_all()
      |> count_and_reset_flashed_octopuses()

    run_steps(new_octopuses, steps - 1, total_flashes + count_of_flashes)
  end

  defp increase_all(octopuses) do
    Enum.reduce(octopuses, octopuses, fn {coordinates, _}, octopuses ->
      increase_octopus(coordinates, octopuses)
    end)
  end

  defp increase_octopus(coordinates, octopuses) do
    current_value = octopuses[coordinates]
    octopuses = Map.put(octopuses, coordinates, current_value + 1)

    if current_value == 9 do
      coordinates
      |> neighbors()
      |> Enum.filter(&Map.has_key?(octopuses, &1))
      |> Enum.reduce(octopuses, &increase_octopus/2)
    else
      octopuses
    end
  end

  defp count_and_reset_flashed_octopuses(octopuses) do
    Enum.reduce(octopuses, {octopuses, 0}, fn {coordinates, value}, {octopuses, count} ->
      if value >= 10 do
        {Map.put(octopuses, coordinates, 0), count + 1}
      else
        {octopuses, count}
      end
    end)
  end

  defp neighbors({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x + 1, y + 1},
      {x - 1, y - 1},
      {x - 1, y + 1}
    ]
  end

  # defp print_grid(board) do
  #   coordinates = Map.keys(board)
  #   all_xs = Enum.map(coordinates, &elem(&1, 0))
  #   all_ys = Enum.map(coordinates, &elem(&1, 1))
  #   max_y = Enum.max(all_ys)
  #   max_x = Enum.max(all_xs)

  #   0..max_y
  #   |> Enum.map_join("\n", fn y ->
  #     Enum.map_join(0..max_x, " ", fn x ->
  #       board[{x, y}]
  #     end)
  #   end)
  #   |> IO.puts()
  # end
end
