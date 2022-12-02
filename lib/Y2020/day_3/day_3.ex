defmodule Aoc.Y2020.Day3 do
  use Aoc.Day

  @part_two_slopes [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

  answers do
    part_1 173
    part_2 4_385_176_320
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
    end
  end

  solutions do
    part_1 &solve(3, 1, &1)

    part_2 fn input ->
      @part_two_slopes
      |> Enum.map(fn {right, down} -> solve(right, down, input) end)
      |> Enum.reduce(&Kernel.*/2)
    end
  end

  def solve(right, down, input, trail \\ 0, count \\ 0)

  def solve(_, _, [], _trail, count), do: count

  def solve(right, 2, [row, _ | rest], trail, count) do
    solve(right, 2, rest, trail + right, count + check_row(row, trail))
  end

  def solve(right, down, [row | rest], trail, count) do
    solve(right, down, rest, trail + right, count + check_row(row, trail))
  end

  defp check_row(row, trail) do
    row
    |> Stream.cycle()
    |> Stream.drop(trail)
    |> Enum.take(1)
    |> case do
      ["#"] -> 1
      ["."] -> 0
      [] -> 0
    end
  end
end
