defmodule Aoc.Y2015.Day2 do
  use Aoc.Day

  answers do
    part_1 1_606_483
    part_2 3_842_356
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split("x")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(fn {l, w, h} ->
        sides = [l * w, l * h, h * w]

        sides
        |> Enum.map(&(&1 * 2))
        |> Enum.sum()
        |> Kernel.+(Enum.min(sides))
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(fn {l, w, h} ->
        [l * 2 + w * 2, l * 2 + h * 2, h * 2 + w * 2] |> Enum.min() |> Kernel.+(l * w * h)
      end)
      |> Enum.sum()
    end
  end
end
