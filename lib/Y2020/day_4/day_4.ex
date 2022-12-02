defmodule Aoc.Y2020.Day4 do
  use Aoc.Day

  @required ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  @alpha ~w(0 1 2 3 4 5 6 7 8 9)
  @alphanum @alpha ++ ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  @eye_colors ~w(amb blu brn gry grn hzl oth)

  answers do
    part_1 230
    part_2 156
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, ~r/(\s)/))
      |> Enum.map(fn key_vals ->
        key_vals
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.split(&1, ":"))
        |> Enum.into(%{}, fn [key, value] ->
          {key, value}
        end)
      end)
    end
  end

  solutions do
    part_1 fn input ->
      Enum.count(input, fn passport ->
        Enum.all?(@required, &Map.has_key?(passport, &1))
      end)
    end

    part_2 fn input ->
      Enum.count(input, fn passport ->
        Enum.all?(@required, &Map.has_key?(passport, &1)) && validate_fields(passport)
      end)
    end
  end

  defp validate_fields(passport) do
    Enum.all?(passport, fn
      {"byr", value} ->
        value = String.to_integer(value)
        value >= 1920 && value <= 2002

      {"iyr", value} ->
        value = String.to_integer(value)
        value >= 2010 && value <= 2020

      {"eyr", value} ->
        value = String.to_integer(value)
        value >= 2020 && value <= 2030

      {"hgt", value} ->
        case Integer.parse(value) do
          {int, "cm"} ->
            int >= 150 && int <= 193

          {int, "in"} ->
            int >= 59 && int <= 76

          _ ->
            false
        end

      {"hcl", "#" <> value} ->
        value
        |> String.graphemes()
        |> Enum.all?(&(&1 in @alphanum))

      {"ecl", value} when value in @eye_colors ->
        true

      {"pid", value} ->
        String.length(value) == 9 &&
          Enum.all?(String.graphemes(value), &(&1 in @alpha))

      {"cid", _} ->
        true

      _ ->
        false
    end)
  end
end
