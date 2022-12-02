defmodule Aoc.Y2021.Day6 do
  use Aoc.Day

  answers do
    part_1 343_441
    part_2 1_569_108_373_832
  end

  input do
    handle_input fn input ->
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(%{}, fn number, acc ->
        Map.update(acc, number, 1, &(&1 + 1))
      end)
    end
  end

  solutions do
    part_1 &simulate_and_count(&1, 80)
    part_2 &simulate_and_count(&1, 256)
  end

  def simulate_and_count(input, count) do
    input
    |> simulate(count)
    |> count_fish()
  end

  defp count_fish(input) do
    input
    |> Map.values()
    |> Enum.sum()
  end

  defp simulate(input, 0), do: input

  defp simulate(input, days_left) do
    input
    |> Enum.reduce(%{}, fn
      {0, number_of_fish}, acc ->
        acc
        |> Map.update(8, number_of_fish, &(&1 + number_of_fish))
        |> Map.update(6, number_of_fish, &(&1 + number_of_fish))

      {days_left, number_of_fish}, acc ->
        Map.update(acc, days_left - 1, number_of_fish, &(&1 + number_of_fish))
    end)
    |> simulate(days_left - 1)
  end
end
