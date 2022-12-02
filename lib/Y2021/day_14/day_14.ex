defmodule Aoc.Y2021.Day14 do
  use Aoc.Day

  answers do
    part_1 2712
    part_2 8_336_623_059_567
  end

  input do
    handle_input fn input ->
      [template, instructions] = String.split(input, "\n\n", trim: true)

      %{
        pairs: parse_pairs(String.graphemes(template)),
        letter_counts: parse_letter_counts(template),
        instructions: parse_instructions(instructions)
      }
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> follow_insertion_rules_n_times(10)
      |> most_common_element_minus_least_common_element()
    end

    part_2 fn input ->
      input
      |> follow_insertion_rules_n_times(40)
      |> most_common_element_minus_least_common_element()
    end
  end

  defp parse_letter_counts(template) do
    template
    |> String.graphemes()
    |> Enum.reduce(%{}, fn letter, acc ->
      Map.update(acc, letter, 1, &Kernel.+(&1, 1))
    end)
  end

  defp parse_pairs(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(%{}, fn pair, acc ->
      Map.update(acc, pair, 1, &Kernel.+(&1, 1))
    end)
  end

  defp parse_instructions(instructions) do
    instructions
    |> String.split("\n", trim: true)
    |> Enum.map(fn instruction ->
      [pair, insertion] = String.split(instruction, " -> ", trim: true)

      %{
        pair: String.graphemes(pair),
        insertion: insertion
      }
    end)
  end

  defp most_common_element_minus_least_common_element(letter_counts) do
    counts = Map.values(letter_counts)

    Enum.max(counts) - Enum.min(counts)
  end

  defp follow_insertion_rules_n_times(%{letter_counts: letter_counts}, 0), do: letter_counts

  defp follow_insertion_rules_n_times(
         %{pairs: pairs, instructions: instructions, letter_counts: letter_counts} = input,
         n
       ) do
    {new_pairs, new_letter_counts} = follow_insertion_rules(pairs, letter_counts, instructions)

    follow_insertion_rules_n_times(
      %{input | pairs: new_pairs, letter_counts: new_letter_counts},
      n - 1
    )
  end

  defp follow_insertion_rules(pairs, letter_counts, instructions) do
    Enum.reduce(pairs, {%{}, letter_counts}, fn {[first, second] = pair, count},
                                                {new_pairs, new_letter_counts} ->
      case Enum.find(instructions, &(&1.pair == pair)) do
        nil ->
          {Map.put(new_pairs, pair, count), new_letter_counts}

        %{insertion: insertion} ->
          new_pairs =
            new_pairs
            |> Map.update([first, insertion], count, &Kernel.+(&1, count))
            |> Map.update([insertion, second], count, &Kernel.+(&1, count))

          new_letter_counts =
            Map.update(new_letter_counts, insertion, count, &Kernel.+(&1, count))

          {new_pairs, new_letter_counts}
      end
    end)
  end
end
