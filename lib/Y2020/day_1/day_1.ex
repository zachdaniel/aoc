defmodule Aoc.Y2020.Day1 do
  use Aoc.Day

  answers do
    part_1 744_475
    part_2 70_276_940
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
    end
  end

  solutions do
    part_1 fn input ->
      Enum.find_value(input, fn number ->
        Enum.find_value(input, fn other_number ->
          if number + other_number == 2020 do
            number * other_number
          end
        end)
      end)
    end

    part_2 fn input ->
      Enum.find_value(input, fn number ->
        Enum.find_value(input, fn other_number ->
          Enum.find_value(input, fn third_number ->
            if number + other_number + third_number == 2020 do
              number * other_number * third_number
            end
          end)
        end)
      end)
    end
  end
end
