defmodule Aoc.Y2022.Day2 do
  use Aoc.Day

  answers do
    part_1 10941
    part_2 13071
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(&List.to_tuple/1)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(&score/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(&score2/1)
      |> Enum.sum()
    end
  end

  defp score({opponent, you}) do
    opponent =
      case opponent do
        "A" -> :rock
        "B" -> :paper
        "C" -> :scissors
      end

    {you, points} =
      case you do
        "X" -> {:rock, 1}
        "Y" -> {:paper, 2}
        "Z" -> {:scissors, 3}
      end

    points + match_points({opponent, you})
  end

  defp score2({opponent, you}) do
    opponent =
      case opponent do
        "A" -> :rock
        "B" -> :paper
        "C" -> :scissors
      end

    you =
      case you do
        "X" ->
          case opponent do
            :rock -> :scissors
            :paper -> :rock
            :scissors -> :paper
          end

        "Y" ->
          opponent

        "Z" ->
          case opponent do
            :rock -> :paper
            :paper -> :scissors
            :scissors -> :rock
          end
      end

    points =
      case you do
        :rock -> 1
        :paper -> 2
        :scissors -> 3
      end

    points + match_points({opponent, you})
  end

  defp match_points({same, same}), do: 3
  defp match_points({:rock, :scissors}), do: 0
  defp match_points({:rock, :paper}), do: 6
  defp match_points({:paper, :rock}), do: 0
  defp match_points({:paper, :scissors}), do: 6
  defp match_points({:scissors, :rock}), do: 6
  defp match_points({:scissors, :paper}), do: 0
end
