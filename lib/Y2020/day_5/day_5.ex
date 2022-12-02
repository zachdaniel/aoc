defmodule Aoc.Y2020.Day5 do
  use Aoc.Day

  answers do
    part_1 858
    part_2 557
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn <<row::binary-size(7)>> <> <<column::binary-size(3)>> ->
        %{row: row, column: column}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> parse_seats()
      |> Enum.max_by(& &1.id)
      |> Map.get(:id)
    end

    part_2 fn input ->
      ids = MapSet.new(parse_seats(input), & &1.id)

      ids
      |> Enum.reject(fn id ->
        MapSet.member?(ids, id + 1) && MapSet.member?(ids, id - 1)
      end)
      |> Enum.sort()
      |> Enum.at(1)
      |> Kernel.+(1)
    end
  end

  defp parse_seats(input) do
    input
    |> Enum.map(fn %{row: row, column: column} = seat ->
      %{seat | row: binary_search(row, "F", "B", 127), column: binary_search(column, "L", "R", 7)}
    end)
    |> Enum.map(fn %{column: column, row: row} = seat ->
      Map.put(seat, :id, row * 8 + column)
    end)
  end

  defp binary_search(string, lower, upper, range) do
    string
    |> String.graphemes()
    |> Enum.reduce(
      {0, range},
      fn
        ^lower, {low, high} ->
          {low, high - div(high - low + 1, 2)}

        ^upper, {low, high} ->
          {low + div(high - low + 1, 2), high}
      end
    )
    |> elem(0)
  end
end
