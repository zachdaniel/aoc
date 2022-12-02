defmodule Aoc.Y2021.Day10 do
  use Aoc.Day

  require Integer

  answers do
    part_1 168_417
    part_2 2_802_519_786
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
    end
  end

  solutions do
    part_1 &score_input(&1)
    part_2 &score_input(&1, :stack)
  end

  defp score_input(input, scoring \\ :invalid_character) do
    scores = Enum.map(input, &syntax_error_score(&1, scoring))

    if scoring == :invalid_character do
      Enum.sum(scores)
    else
      scores =
        scores
        |> Enum.reject(&(&1 == 0))
        |> Enum.sort()

      count = Enum.count(scores)

      if Integer.is_even(count) do
        Enum.at(scores, div(count, 2) - 1)
      else
        Enum.at(scores, div(count - 1, 2))
      end
    end
  end

  defp syntax_error_score(list, scoring, stack \\ [])
  defp syntax_error_score([], :invalid_character, _), do: 0

  defp syntax_error_score([], :stack, stack) do
    score_stack(stack)
  end

  defp syntax_error_score([first | rest], scoring, []) do
    syntax_error_score(rest, scoring, [first])
  end

  defp syntax_error_score([first | rest], scoring, [first_stack | rest_stack] = stack) do
    if closes?(first_stack, first) do
      syntax_error_score(rest, scoring, rest_stack)
    else
      if first in ["}", ")", "]", ">"] do
        if scoring == :invalid_character do
          score_character(first)
        else
          0
        end
      else
        syntax_error_score(rest, scoring, [first | stack])
      end
    end
  end

  defp score_stack(stack) do
    stack
    |> Enum.map(&closer/1)
    |> Enum.reduce(0, fn character, score ->
      character_score =
        case character do
          ")" -> 1
          "]" -> 2
          "}" -> 3
          ">" -> 4
        end

      score * 5 + character_score
    end)
  end

  defp score_character(")"), do: 3
  defp score_character("]"), do: 57
  defp score_character("}"), do: 1197
  defp score_character(">"), do: 25137

  defp closer("("), do: ")"
  defp closer("["), do: "]"
  defp closer("{"), do: "}"
  defp closer("<"), do: ">"
  defp closer(_), do: nil

  defp closes?(left, right) do
    closer(left) == right
  end
end
