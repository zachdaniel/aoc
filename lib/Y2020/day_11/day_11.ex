defmodule Aoc.Y2020.Day11 do
  use Aoc.Day

  answers do
    part_1 2303
    part_2 2057
  end

  input do
    handle_input fn input ->
      input =
        input
        |> String.split("\n")
        |> Enum.map(&String.graphemes/1)

      indexed =
        for {row, row_num} <- Enum.with_index(input),
            {seat, seat_num} <- Enum.with_index(row),
            reduce: %{} do
          acc ->
            Map.put(acc, {row_num, seat_num}, seat)
        end

      height = Enum.count(input)

      %{input: input, indexed: indexed, height: height, width: Enum.count(Enum.at(input, 0))}
    end
  end

  solutions do
    part_1 fn input ->
      input.indexed
      |> run_to_stabilization(
        4,
        {:adjacent, input.height, input.width},
        input.height,
        input.width
      )
      |> Map.values()
      |> Enum.count(&(&1 == "#"))
    end

    part_2 fn input ->
      input.indexed
      |> run_to_stabilization(5, :vision, input.height, input.width)
      |> Map.values()
      |> Enum.count(&(&1 == "#"))
    end
  end

  defp run_to_stabilization(input, adjacency_requirement, adjacency_calc, height, width) do
    result =
      for row_num <- 0..height,
          seat_num <- 0..width,
          reduce: %{} do
        acc ->
          seat = get_seat(input, row_num, seat_num)

          case seat do
            "L" ->
              if no_occupied_seats_next_to?(input, adjacency_calc, row_num, seat_num) do
                push_seat(acc, row_num, seat_num, "#")
              else
                push_seat(acc, row_num, seat_num, "L")
              end

            "#" ->
              if count_adjacent_seats_occupied(input, adjacency_calc, row_num, seat_num) >=
                   adjacency_requirement do
                push_seat(acc, row_num, seat_num, "L")
              else
                push_seat(acc, row_num, seat_num, "#")
              end

            "." ->
              push_seat(acc, row_num, seat_num, ".")

            nil ->
              acc
          end
      end

    if result == input do
      result
    else
      run_to_stabilization(result, adjacency_requirement, adjacency_calc, height, width)
    end
  end

  defp push_seat(acc, row, seat_num, value) do
    Map.put(acc, {row, seat_num}, value)
  end

  defp get_seat(acc, row, seat) do
    Map.get(acc, {row, seat})
  end

  defp count_adjacent_seats_occupied(input, adjacency_calc, row_num, seat_num) do
    Enum.count(adjacent_seats(input, adjacency_calc, row_num, seat_num), fn {row, seat} ->
      get_seat(input, row, seat) == "#"
    end)
  end

  defp no_occupied_seats_next_to?(input, adjacency_calc, row_num, seat_num) do
    not Enum.any?(adjacent_seats(input, adjacency_calc, row_num, seat_num), fn {row, seat} ->
      get_seat(input, row, seat) == "#"
    end)
  end

  def adjacent_seats(_input, {:adjacent, height, width}, row_num, seat_num) do
    [row_num - 1, row_num, row_num + 1]
    |> Enum.flat_map(fn row ->
      Enum.map([seat_num - 1, seat_num, seat_num + 1], fn seat ->
        {row, seat}
      end)
    end)
    |> Enum.reject(fn {row, seat} ->
      row < 0 || seat < 0 || row > height || seat > width || (row_num == row && seat_num == seat)
    end)
  end

  def adjacent_seats(input, :vision, row_num, seat_num) do
    [-1, 0, 1]
    |> Enum.flat_map(fn row_scale ->
      Enum.map([-1, 0, 1], fn col_scale ->
        {row_scale, col_scale}
      end)
    end)
    |> Enum.reject(fn {row, seat} ->
      row == 0 and seat == 0
    end)
    |> Enum.flat_map(fn {col_scale, row_scale} ->
      List.wrap(seek_seat(input, row_num, seat_num, row_scale, col_scale))
    end)
  end

  defp seek_seat(input, row_num, seat_num, row_scale, col_scale) do
    case get_seat(input, row_num + row_scale, seat_num + col_scale) do
      nil -> nil
      "." -> seek_seat(input, row_num + row_scale, seat_num + col_scale, row_scale, col_scale)
      seat when seat in ["#", "L"] -> {row_num + row_scale, seat_num + col_scale}
    end
  end
end
