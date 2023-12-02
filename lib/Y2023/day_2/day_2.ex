defmodule Aoc.Y2023.Day2 do
  use Aoc.Day

  answers do
    part_1 2156
    part_2 66909
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn "Game " <> number ->
        {game_number, rest} = Integer.parse(number)
        ": " <> colors = rest

        {game_number, colors(colors)}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.filter(&part_one_possible?/1)
      |> Enum.map(&elem(&1, 0))
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(&power/1)
      |> Enum.sum()
    end
  end

  @limits %{
    "blue" => 14,
    "red" => 12,
    "green" => 13
  }

  defp part_one_possible?({_game, pullings}) do
    Enum.all?(pullings, fn pulling ->
      Enum.all?(pulling, fn {color, number} ->
        @limits[color] >= number
      end)
    end)
  end

  defp colors(string) do
    string
    |> String.split("; ")
    |> Enum.map(fn pulling ->
      pulling
      |> String.split(", ")
      |> Enum.map(fn number_and_color ->
        {number, color} = Integer.parse(number_and_color)

        {number, String.trim(color)}
      end)
      |> Enum.reduce(%{}, fn {number, color}, acc ->
        Map.update(acc, color, number, &(&1 + number))
      end)
    end)
  end

  defp power({_game, pullings}) do
    pullings
    |> Enum.reduce(%{}, fn pulling, acc ->
      pulling
      |> Enum.reduce(acc, fn {color, number}, acc ->
        Map.update(acc, color, number, &max(&1, number))
      end)
    end)
    |> Map.values()
    |> Enum.reduce(1, &Kernel.*/2)
  end
end
