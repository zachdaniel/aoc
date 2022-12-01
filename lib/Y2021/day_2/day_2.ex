defmodule Aoc.Y2021.Day2 do
  use Aoc.Day

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        [instruction, amount] = String.split(line, " ")
        %{instruction: instruction, amount: String.to_integer(amount)}
      end)
    end
  end

  # solutions do
  #   part_1 fn input ->
  #     input
  #     |> Enum.reduce(
  #       %{depth: 0, horizontal: 0},
  #       &follow_part_1_instruction/2
  #     )
  #     |> multiply_position()
  #   end
  # end
end
