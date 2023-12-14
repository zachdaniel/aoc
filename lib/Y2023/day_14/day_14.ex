defmodule Aoc.Y2023.Day14 do
  use Aoc.Day
  use Nebulex.Caching

  answers do
    part_1 112_048
    part_2 105_606
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> string_to_grid(
        with_size?: true,
        type: :rows,
        char_handler: fn
          "." ->
            :ignore

          char ->
            {:keep, char}
        end
      )
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> tilt_all_the_way(:up)
      |> calculate_load()
    end

    part_2 fn input ->
      limit = 4_000_000_000
      directions = [:up, :left, :down, :right]

      directions
      |> Stream.cycle()
      |> Stream.take(limit)
      |> Stream.with_index()
      |> Enum.reduce_while({input, %{}}, fn {towards, index}, {input, cache} ->
        case cache[input] do
          nil ->
            new = tilt_all_the_way(input, towards)
            {:cont, {new, Map.put(cache, input, index)}}

          started_at ->
            {:halt, {input, towards, index, started_at}}
        end
      end)
      |> case do
        {input, towards, index, started_at} ->
          size = index - started_at
          {left, right} = Enum.split_while(directions, &(&1 != towards))

          (right ++ left)
          |> Stream.cycle()
          |> Stream.take(rem(limit - started_at, size))
          |> Enum.reduce(input, &tilt_all_the_way(&2, &1))
          |> calculate_load()

        _ ->
          raise "no way"
      end
    end
  end

  import Aoc.Helpers

  defp calculate_load(%{grid: grid}) do
    grid
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {line, index} ->
      line
      |> Enum.count(&(&1 == "O"))
      |> Kernel.*(index)
    end)
    |> Enum.sum()
  end

  defp tilt_all_the_way(input, towards) do
    case tilt(input, towards) do
      ^input -> input
      new -> tilt_all_the_way(new, towards)
    end
  end

  defp tilt(input, :left) do
    Map.update!(input, :grid, fn grid ->
      Enum.map(grid, &fill_left/1)
    end)
  end

  defp tilt(input, :right) do
    Map.update!(input, :grid, fn grid ->
      Enum.map(grid, fn line ->
        line |> Enum.reverse() |> fill_left() |> Enum.reverse()
      end)
    end)
  end

  defp tilt(input, :up) do
    Map.update!(input, :grid, fn grid ->
      grid
      |> transpose_left()
      |> Enum.map(&fill_left/1)
      |> transpose_right()
    end)
  end

  defp tilt(input, :down) do
    Map.update!(input, :grid, fn grid ->
      grid
      |> transpose_right()
      |> Enum.map(&fill_left/1)
      |> transpose_left()
    end)
  end

  defp transpose_left(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reverse()
  end

  defp transpose_right(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(fn row ->
      row
      |> Tuple.to_list()
      |> Enum.reverse()
    end)
  end

  def fill_left(row, acc \\ [])
  def fill_left([], acc), do: Enum.reverse(acc)

  def fill_left(["#" | rest], acc) do
    fill_left(rest, ["#" | acc])
  end

  def fill_left(rest, acc) do
    {shifting, rest} =
      Enum.split_while(rest, &(&1 != "#"))

    {rocks, empties} =
      shifting
      |> Enum.split_with(&(&1 == "O"))

    fill_left(rest, empties ++ rocks ++ acc)
  end
end
