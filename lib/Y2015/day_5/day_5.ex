defmodule Aoc.Y2015.Day5 do
  use Aoc.Day

  answers do
    part_1 236
    part_2 51
  end

  input do
    handle_input fn input ->
      String.split(input, "\n")
    end
  end

  solutions do
    part_1 fn input ->
      Enum.count(input, &first_nice?/1)
    end

    part_2 fn input ->
      Enum.count(input, &second_nice?/1)
    end
  end

  defp second_nice?(string) do
    has_pair? =
      Enum.any?(?a..?z, fn first ->
        Enum.any?(?a..?z, fn second ->
          find = to_string([first, second])

          String.contains?(string, find) &&
            String.contains?(String.replace(string, find, "-", global: false), find)
        end)
      end)

    has_triple? =
      Enum.any?(?a..?z, fn first ->
        Enum.any?(?a..?z, fn second ->
          String.contains?(string, to_string([first, second, first]))
        end)
      end)

    has_pair? && has_triple?
  end

  defp first_nice?(string) do
    vowels =
      string
      |> String.replace(~r/[^aeiou]/, "")
      |> String.length()

    vowels >= 3 &&
      Enum.any?(?a..?z, fn char ->
        String.contains?(string, "#{to_string([char])}#{to_string([char])}")
      end) &&
      Enum.all?(~w(ab cd pq xy), fn bad ->
        !String.contains?(string, bad)
      end)
  end
end
