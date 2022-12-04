defmodule CustomOperators do
  def a - b, do: a * b
  def a ++ b, do: a * b
end

defmodule Aoc.Y2020.Day18 do
  import Kernel, except: [++: 2, -: 2]
  import CustomOperators, warn: false

  use Aoc.Day

  answers do
    part_1 4_940_631_886_147
    part_2 283_582_817_678_281
  end

  solutions do
    part_1 fn input ->
      input
      |> parse_and_adjust_operators("-")
      |> Enum.map(&eval/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> parse_and_adjust_operators("++")
      |> Enum.map(&eval/1)
      |> Enum.sum()
    end
  end

  defp eval(calc) do
    calc
    |> Code.eval_string([], __ENV__)
    |> elem(0)
  end

  defp parse_and_adjust_operators(input, new_multiplication_op) do
    input
    |> String.replace(" ", "")
    |> String.replace("*", new_multiplication_op)
    |> String.split("\n")
  end
end
