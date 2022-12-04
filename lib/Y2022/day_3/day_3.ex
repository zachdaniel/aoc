defmodule Aoc.Y2022.Day3 do
  use Aoc.Day

  @priorities Enum.concat(?a..?z, ?A..?Z)
              |> Enum.with_index()
              |> Map.new(fn {c, i} -> {to_string([c]), i + 1} end)
  answers do
    part_1 8153
    part_2 2342
  end

  input do
    handle_input &String.split(&1, "\n")
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(fn sack ->
        String.split_at(sack, div(String.length(sack), 2))
      end)
      |> Enum.map(fn {l, r} ->
        l
        |> String.graphemes()
        |> Enum.find(&String.contains?(r, &1))
        |> then(&Map.get(@priorities, &1))
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.chunk_every(3)
      |> Enum.map(fn [first | rest] ->
        first
        |> String.graphemes()
        |> Enum.find(fn char ->
          Enum.all?(rest, &String.contains?(&1, char))
        end)
        |> then(&Map.get(@priorities, &1))
      end)
      |> Enum.sum()
    end
  end
end
