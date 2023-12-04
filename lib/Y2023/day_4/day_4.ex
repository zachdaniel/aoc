defmodule Aoc.Y2023.Day4 do
  use Aoc.Day

  answers do
    part_1 20117
    part_2 13_768_818
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn "Card " <> rest ->
        {card_number, ": " <> rest} = Integer.parse(String.trim(rest))
        [winning_numbers, numbers] = String.split(rest, " | ")

        winning_numbers =
          Enum.map(String.split(winning_numbers, " ", trim: true), &String.to_integer/1)

        numbers = Enum.map(String.split(numbers, " ", trim: true), &String.to_integer/1)

        {card_number, winning_numbers, numbers}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(fn {_, winning_numbers, numbers} ->
        case Enum.count(winning_numbers, &(&1 in numbers)) do
          0 ->
            0

          win_count ->
            1 * round(:math.pow(2, win_count - 1))
        end
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      card_nums_to_numbers =
        input
        |> Map.new(fn {card_number, winning_numbers, numbers} ->
          {card_number, {winning_numbers, numbers}}
        end)

      card_nums_to_numbers
      |> Enum.sort_by(&elem(&1, 0), :desc)
      |> Enum.reduce({Enum.count(input), %{}}, fn {card_number, {winning_numbers, numbers}},
                                                  {card_count, cache} ->
        {new_cards_gotten, cache} =
          count_wins(card_nums_to_numbers, card_number, cache)

        {card_count + new_cards_gotten, cache}
      end)
      |> elem(0)
    end
  end

  defp count_wins(card_nums_to_numbers, card_number, cache) do
    case Map.fetch(cache, card_number) do
      {:ok, count} ->
        {count, cache}

      :error ->
        case Map.fetch(card_nums_to_numbers, card_number) do
          :error ->
            {0, Map.put(cache, card_number, 0)}

          {:ok, {winning_numbers, numbers}} ->
            case Enum.count(winning_numbers, &(&1 in numbers)) do
              0 ->
                {0, cache}

              win_count ->
                {new_cards, cache} =
                  Enum.reduce(1..win_count, {0, cache}, fn to_add, {new_cards, cache} ->
                    {new_new_cards, cache} =
                      count_wins(card_nums_to_numbers, card_number + to_add, cache)

                    {new_cards + new_new_cards, cache}
                  end)

                {new_cards + win_count, Map.put(cache, card_number, new_cards + win_count)}
            end
        end
    end
  end
end
