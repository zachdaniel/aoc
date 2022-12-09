defmodule Aoc.Y2022.Day8 do
  use Aoc.Day

  answers do
    part_1 1807
    part_2 480000
  end

  input do
    handle_input fn input ->
      [first | _] = rows =
      input
      |> String.split("\n")

      dimensions = {String.length(first), Enum.count(rows)}

      grid =
        rows
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {row, row_num}, acc ->
          row
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {tree, col_num}, acc ->
            Map.put(acc, {row_num, col_num}, String.to_integer(tree))
          end)
        end)

      {dimensions, grid}
    end
  end

  solutions do
    part_1 fn {{x_dim, y_dim}, grid} ->
      for x <- 0..(x_dim - 1), y <- 0..(y_dim - 1) do
        {x, y}
      end
      |> Enum.reduce(0, fn {x, y}, acc ->
        if x == 0 or y == 0 or x == x_dim - 1 or y == y_dim - 1 do
          acc + 1
        else
          if visible?({x, y}, {x_dim, y_dim}, grid) do
            acc + 1
          else
            acc
          end
        end
      end)
    end

    part_2 fn {{x_dim, y_dim}, grid} ->
      for x <- 0..(x_dim - 1), y <- 0..(y_dim - 1), x != 0 and y != 0 and x != x_dim - 1 and y != y_dim - 1 do
        {x, y}
      end
      |> Enum.map(&scenic_score(&1, {x_dim, y_dim}, grid))
      |> Enum.max()
    end
  end

  defp scenic_score({x, y}, {x_dim, y_dim}, grid) do
    height = grid[{x, y}]
    [
      points_up({x, y}, {x_dim, y_dim}),
      points_left({x, y}, {x_dim, y_dim}),
      points_right({x, y}, {x_dim, y_dim}),
      points_down({x, y}, {x_dim, y_dim})
    ]
    |> Enum.map(fn points ->
      {trees, remaining} =
        points
        |> Enum.split_while(fn point ->
          grid[point] < height
        end)

      case remaining do
        [] ->
          Enum.count(trees)
        _ ->
          Enum.count(trees) + 1
      end
    end)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp visible?({x, y}, {x_dim, y_dim}, grid) do
    height = grid[{x, y}]
    [
      points_left({x, y}, {x_dim, y_dim}),
      points_up({x, y}, {x_dim, y_dim}),
      points_down({x, y}, {x_dim, y_dim}),
      points_right({x, y}, {x_dim, y_dim})
    ]
    |> Enum.any?(fn points ->
      Enum.all?(points, fn point ->
        grid[point] < height
      end)
    end)
  end

  def points_left({x, y}, {_x_dim, _y_dim}) do
    for check_x <- (x - 1)..0 do
      {check_x, y}
    end
  end

  def points_right({x, y}, {x_dim, _y_dim}) do
    for check_x <- (x + 1)..(x_dim - 1) do
      {check_x, y}
    end
  end

  def points_down({x, y}, {_x_dim, y_dim}) do
    for check_y <- (y + 1)..(y_dim - 1) do
      {x, check_y}
    end
  end

  def points_up({x, y}, {_x_dim, _y_dim}) do
    for check_y <- (y - 1)..0 do
      {x, check_y}
    end
  end
end
