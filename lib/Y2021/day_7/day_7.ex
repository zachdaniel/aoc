defmodule Aoc.Y2021.Day7 do
  use Aoc.Day

  answers do
    part_1 352_254
    part_2 99_053_143
  end

  input do
    handle_input fn input ->
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end
  end

  solutions do
    part_1 &find_optimal_horizontal_position/1
    part_2 &find_optimal_horizontal_position(&1, true)
  end

  defp find_optimal_horizontal_position(input, increasing_fuel_cost? \\ false) do
    highest_crab = Enum.max(input)
    lowest_crab = Enum.min(input)

    Enum.reduce(
      lowest_crab..highest_crab,
      nil,
      fn potential_horizontal_position, least_fuel_intensive_position ->
        fuel_expended =
          input
          |> Enum.map(fn crab_position ->
            if increasing_fuel_cost? do
              increasing_fuel_expense(crab_position, potential_horizontal_position)
            else
              abs(crab_position - potential_horizontal_position)
            end
          end)
          |> Enum.sum()

        if least_fuel_intensive_position do
          min(least_fuel_intensive_position, fuel_expended)
        else
          fuel_expended
        end
      end
    )
  end

  defp increasing_fuel_expense(start, finish) do
    difference = abs(start - finish) + 1
    div(difference * (difference - 1), 2)
  end
end
