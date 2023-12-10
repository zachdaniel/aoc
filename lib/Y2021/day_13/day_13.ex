defmodule Aoc.Y2021.Day13 do
  use Aoc.Day

  answers do
    part_1 712
    part_2 "BLHFJPJF"
    part_2_visual?(true)
  end

  input do
    handle_input fn input ->
      [coordinates, instructions] = String.split(input, "\n\n", trim: true)
      grid = parse_grid(coordinates)

      %{
        grid: grid,
        instructions: parse_instructions(instructions)
      }
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Map.update!(:instructions, &Enum.take(&1, 1))
      |> follow_fold_instructions()
      |> count_dots()
    end

    part_2 fn input ->
      input
      |> follow_fold_instructions()
      |> grid()
    end
  end

  defp parse_grid(coordinates) do
    coordinates
    |> String.split("\n", trim: true)
    |> Enum.reduce(MapSet.new(), fn coordinates, grid ->
      [x, y] = String.split(coordinates, ",", trim: true)
      MapSet.put(grid, {String.to_integer(x), String.to_integer(y)})
    end)
  end

  defp parse_instructions(instructions) do
    instructions
    |> String.split("\n")
    |> Enum.map(fn instruction ->
      instruction = String.trim_leading(instruction, "fold along ")
      [axis, coordinate] = String.split(instruction, "=", trim: true)

      %{axis: axis, coordinate: String.to_integer(coordinate)}
    end)
  end

  defp follow_fold_instructions(%{grid: grid, instructions: []}) do
    grid
  end

  defp follow_fold_instructions(%{grid: grid, instructions: [instruction | rest]}) do
    result = follow_fold_instruction(grid, instruction)
    follow_fold_instructions(%{grid: result, instructions: rest})
  end

  defp follow_fold_instruction(grid, %{axis: "x", coordinate: coordinate}) do
    Enum.reduce(grid, MapSet.new(), fn {x, y}, new_grid ->
      cond do
        x == coordinate ->
          new_grid

        x < coordinate ->
          MapSet.put(new_grid, {x, y})

        true ->
          MapSet.put(new_grid, {coordinate - (x - coordinate), y})
      end
    end)
  end

  defp follow_fold_instruction(grid, %{axis: "y", coordinate: coordinate}) do
    Enum.reduce(grid, MapSet.new(), fn {x, y}, new_grid ->
      cond do
        y == coordinate ->
          new_grid

        y < coordinate ->
          MapSet.put(new_grid, {x, y})

        true ->
          MapSet.put(new_grid, {x, coordinate - (y - coordinate)})
      end
    end)
  end

  defp grid(grid) do
    max_x = Enum.max(Enum.map(grid, &elem(&1, 0)))
    max_y = Enum.max(Enum.map(grid, &elem(&1, 1)))

    0..max_y
    |> Enum.map_join("\n", fn y ->
      0..max_x
      |> Enum.map_join("", fn x ->
        if MapSet.member?(grid, {x, y}) do
          "#"
        else
          "."
        end
      end)
    end)
  end

  defp count_dots(grid) do
    MapSet.size(grid)
  end
end
