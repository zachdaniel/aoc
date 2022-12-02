defmodule Aoc.Y2020.Day22 do
  use Aoc.Day

  answers do
    part_1 33473
    part_2 31793
  end

  input do
    handle_input fn input ->
      [player1, player2] =
        input
        |> String.split("\n\n")
        |> Enum.map(&String.split(&1, "\n"))
        |> Enum.map(&Enum.drop(&1, 1))

      %{
        player1: Enum.map(player1, &String.to_integer/1),
        player2: Enum.map(player2, &String.to_integer/1)
      }
    end
  end

  solutions do
    part_1 fn input ->
      input.player1
      |> play(input.player2)
      |> score()
    end

    part_2 fn input ->
      input.player1
      |> play_recursive(input.player2)
      |> elem(1)
      |> score
    end
  end

  defp score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {card, index} ->
      (index + 1) * card
    end)
    |> Enum.sum()
  end

  defp play_recursive(player1, player2, played \\ MapSet.new())
  defp play_recursive([], player2, _), do: {:player2, player2}
  defp play_recursive(player1, [], _), do: {:player1, player1}

  defp play_recursive(
         [player1 | player1_remaining] = all_player1,
         [player2 | player2_remaining] = all_player2,
         played
       ) do
    if MapSet.member?(played, [all_player1, all_player2]) do
      {:player1, all_player1}
    else
      played = MapSet.put(played, [all_player1, all_player2])

      winner =
        if Enum.count(player1_remaining) >= player1 && Enum.count(player2_remaining) >= player2 do
          {winner, _} =
            play_recursive(
              Enum.take(player1_remaining, player1),
              Enum.take(player2_remaining, player2)
            )

          winner
        else
          if player1 > player2 do
            :player1
          else
            :player2
          end
        end

      case winner do
        :player1 ->
          play_recursive(player1_remaining ++ [player1, player2], player2_remaining, played)

        :player2 ->
          play_recursive(player1_remaining, player2_remaining ++ [player2, player1], played)
      end
    end
  end

  defp play(player1, player2)
  defp play([], win), do: win
  defp play(win, []), do: win

  defp play([player1 | player1_rest], [player2 | player2_rest]) when player1 > player2 do
    play(player1_rest ++ [player1, player2], player2_rest)
  end

  defp play([player1 | player1_rest], [player2 | player2_rest]) when player1 < player2 do
    play(player1_rest, player2_rest ++ [player2, player1])
  end
end
