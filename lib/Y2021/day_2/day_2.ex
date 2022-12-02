defmodule Aoc.Y2021.Day2 do
  use Aoc.Day

  answers do
    part_1 2_147_104
    part_2 2_044_620_088
  end

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

  solutions do
    part_1 fn input ->
      input
      |> Enum.reduce(
        %{depth: 0, horizontal: 0},
        &follow_part_1_instruction/2
      )
      |> multiply_position()
    end

    part_2 fn input ->
      input
      |> Enum.reduce(
        %{depth: 0, horizontal: 0, aim: 0},
        &follow_part_2_instruction/2
      )
      |> multiply_position()
    end
  end

  defp follow_part_2_instruction(
         %{instruction: "forward", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal,
           aim: aim
         }
       ) do
    %{depth: depth + aim * amount, horizontal: horizontal + amount, aim: aim}
  end

  defp follow_part_2_instruction(
         %{instruction: "up", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal,
           aim: aim
         }
       ) do
    %{depth: depth, horizontal: horizontal, aim: aim - amount}
  end

  defp follow_part_2_instruction(
         %{instruction: "down", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal,
           aim: aim
         }
       ) do
    %{depth: depth, horizontal: horizontal, aim: aim + amount}
  end

  defp follow_part_1_instruction(
         %{instruction: "forward", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal
         }
       ) do
    %{depth: depth, horizontal: horizontal + amount}
  end

  defp follow_part_1_instruction(
         %{instruction: "up", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal
         }
       ) do
    %{depth: depth - amount, horizontal: horizontal}
  end

  defp follow_part_1_instruction(
         %{instruction: "down", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal
         }
       ) do
    %{depth: depth + amount, horizontal: horizontal}
  end

  defp multiply_position(%{depth: depth, horizontal: horizontal}), do: depth * horizontal
end
