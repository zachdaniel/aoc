defmodule Aoc.Y2023.Day13 do
  use Aoc.Day

  answers do
    part_1 35691
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n\n")
      |> Enum.map(fn board ->
        board =
          board
          |> String.split("\n")
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {row, y}, acc ->
            row
            |> String.graphemes()
            |> Enum.with_index()
            |> Enum.reduce(acc, fn {cell, x}, acc ->
              value =
                case cell do
                  "." -> :ash
                  "#" -> :rocks
                end

              Map.put(acc, {x, -y}, value)
            end)
          end)

        keys = Map.keys(board)
        max_x = keys |> Enum.map(&elem(&1, 0)) |> Enum.max()
        min_y = keys |> Enum.map(&elem(&1, 1)) |> Enum.min()

        %{board: board, max_x: max_x, min_y: min_y}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(fn board ->
        0..(board.max_x - 1)
        |> Enum.map(&{:x, &1})
        |> Enum.concat(Enum.map(0..(board.min_y + 1), &{:y, &1}))
        |> Enum.find(&reflects?(board, &1))
        |> score_reflection()
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(fn board ->
        0..(board.max_x - 1)
        |> Enum.map(&{:x, &1})
        |> Enum.concat(Enum.map(0..(board.min_y + 1), &{:y, &1}))
        |> Enum.find(&reflects?(board, &1, 1))
        |> score_reflection()
      end)
      |> Enum.sum()
    end
  end

  defp reflects?(board, over, tolerance \\ 0)

  defp reflects?(%{board: board, min_y: min_y}, {:x, col}, tolerance) do
    0..col
    |> Stream.flat_map(fn x ->
      0..min_y
      |> Stream.map(fn y ->
        {x, y}
      end)
    end)
    |> Stream.map(fn point ->
      {point, transpose(point, :x, col)}
    end)
    |> matches_with_tolerance(board, tolerance)
  end

  defp reflects?(%{board: board, max_x: max_x}, {:y, row}, tolerance) do
    0..row
    |> Stream.flat_map(fn y ->
      0..max_x
      |> Stream.map(fn x ->
        {x, y}
      end)
    end)
    |> Stream.map(fn point ->
      {point, transpose(point, :y, row)}
    end)
    |> matches_with_tolerance(board, tolerance)
  end

  defp matches_with_tolerance(points, board, tolerance) do
    Enum.reduce_while(points, {true, tolerance + 1}, fn
      _, {_, 0} ->
        {:halt, false}

      {point, other_point}, {matches?, tolerance} ->
        cond do
          is_nil(board[other_point]) ->
            {:cont, {matches?, tolerance}}

          board[point] == board[other_point] ->
            {:cont, {matches?, tolerance}}

          true ->
            {:cont, {matches?, tolerance - 1}}
        end
    end)
    |> case do
      {true, 1} ->
        true

      _ ->
        false
    end
  end

  defp transpose({x, y}, :x, col) do
    {col + (col - x) + 1, y}
  end

  defp transpose({x, y}, :y, row) do
    {x, row - (y - row) - 1}
  end

  defp score_reflection({:x, number}), do: number + 1
  defp score_reflection({:y, number}), do: (-number + 1) * 100
end
