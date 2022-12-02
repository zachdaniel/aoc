defmodule Aoc.Y2021.Day8 do
  use Aoc.Day

  answers do
    part_1 362
    part_2 1_020_159
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        [all_combinations, output] = String.split(line, " | ")

        %{
          all_combinations: split_and_sort(all_combinations),
          output: split_and_sort(output)
        }
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(fn %{output: output} ->
        Enum.count(output, fn digit_string ->
          String.length(digit_string) in [2, 4, 3, 7]
        end)
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(fn %{all_combinations: all_combinations, output: output} ->
        {one, remaining_combinations} =
          find_combination(all_combinations, &(String.length(&1) == 2))

        {four, remaining_combinations} =
          find_combination(remaining_combinations, &(String.length(&1) == 4))

        {seven, remaining_combinations} =
          find_combination(remaining_combinations, &(String.length(&1) == 3))

        {eight, remaining_combinations} =
          find_combination(remaining_combinations, &(String.length(&1) == 7))

        {six, remaining_combinations} =
          find_combination(remaining_combinations, fn combination ->
            String.length(combination) == 6 &&
              not (one |> String.graphemes() |> Enum.all?(&String.contains?(combination, &1)))
          end)

        {nine, remaining_combinations} =
          find_combination(remaining_combinations, fn combination ->
            String.length(combination) == 6 &&
              four |> String.graphemes() |> Enum.all?(&String.contains?(combination, &1))
          end)

        {zero, remaining_combinations} =
          find_combination(remaining_combinations, &(String.length(&1) == 6))

        {three, remaining_combinations} =
          find_combination(remaining_combinations, fn combination ->
            String.length(combination) == 5 &&
              one |> String.graphemes() |> Enum.all?(&String.contains?(combination, &1))
          end)

        top_right_segment = one |> String.graphemes() |> Enum.find(&(!String.contains?(six, &1)))

        {two, [five]} =
          find_combination(remaining_combinations, fn combination ->
            String.contains?(combination, top_right_segment)
          end)

        output
        |> Enum.map(fn
          ^zero ->
            0

          ^one ->
            1

          ^two ->
            2

          ^three ->
            3

          ^four ->
            4

          ^five ->
            5

          ^six ->
            6

          ^seven ->
            7

          ^eight ->
            8

          ^nine ->
            9
        end)
        |> Enum.join()
        |> String.to_integer()
      end)
      |> Enum.sum()
    end
  end

  defp find_combination(all_combinations, func) do
    {[digit_string], remaining_combinations} = Enum.split_with(all_combinations, func)

    {digit_string, remaining_combinations}
  end

  defp split_and_sort(string) do
    string
    |> String.split(" ")
    |> Enum.map(fn digit ->
      digit |> String.split("") |> Enum.sort() |> Enum.join()
    end)
  end
end
