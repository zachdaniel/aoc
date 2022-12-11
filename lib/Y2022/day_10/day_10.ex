defmodule Aoc.Y2022.Day10 do
  use Aoc.Day

  @thresholds [20, 60, 100, 140, 180, 220]

  answers do
    part_1 13060
    part_2 "FJUBULRZ"
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn cmd ->
        case String.split(cmd, " ", trim: true) do
          [cmd] -> String.to_atom(cmd)
          [cmd, value] -> {String.to_atom(cmd), String.to_integer(value)}
        end
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> compute()
      |> Map.get(:sum)
    end

    part_2 fn input ->
      result = compute(input)

      0..(result.row - 1)
      |> Enum.map_join("\n", fn row ->
        0..39
        |> Enum.map_join(fn col ->
          Map.get(result.pixels, {row, col}) || "x"
        end)
      end)
    end
  end

  defp compute(instructions) do
    instructions
    |> Enum.reduce(
      %{
        cycle: 0,
        x: 1,
        sum: 0,
        thresholds: @thresholds,
        pixels: %{},
        col: 0,
        row: 0
      },
      fn
        :noop, data ->
          data
          |> Map.update!(:cycle, &(&1 + 1))
          |> write_pixel()
          |> record_if_crossed()

        {:addx, value}, data ->
          data
          |> Map.update!(:cycle, &(&1 + 1))
          |> write_pixel()
          |> record_if_crossed()
          |> Map.update!(:cycle, &(&1 + 1))
          |> write_pixel()
          |> record_if_crossed()
          |> Map.update!(:x, &(&1 + value))
      end
    )
  end

  defp record_if_crossed(data) do
    data =
      if rem(data.cycle, 40) == 0 do
        %{data | col: 0, row: data.row + 1}
      else
        %{data | col: data.col + 1}
      end

    if data.cycle == List.first(data.thresholds) do
      %{data | sum: data.sum + data.x * data.cycle, thresholds: tl(data.thresholds)}
    else
      data
    end
  end

  defp record_if_crossed_with_pixels(%{thresholds: [next | rest]} = data) do
    if data.cycle == next do
      %{
        data
        | sum: data.sum + next * data.x,
          thresholds: rest,
          row: data.row + 1,
          col: 0
      }
    else
      %{data | col: data.col + 1}
    end
  end

  defp write_pixel(data) do
    if data.x in [data.col - 1, data.col, data.col + 1] do
      %{data | pixels: Map.put(data.pixels, {data.row, data.col}, "#")}
    else
      %{data | pixels: Map.put(data.pixels, {data.row, data.col}, ".")}
    end
  end
end
