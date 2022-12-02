defmodule Aoc.Y2020.Day7 do
  use Aoc.Day

  answers do
    part_1 208
    part_2 1664
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn rule ->
        [bag_name, contains] = String.split(rule, " bags contain ", parts: 2)
        {bag_name, contains}
      end)
      |> Enum.into(%{}, fn {bag_name, contains} ->
        new_contains =
          contains
          |> String.split(~r/(\,\s|\.$)/)
          |> Enum.map(&String.trim_trailing(&1, "bags"))
          |> Enum.map(&String.trim_trailing(&1, "bag"))
          |> Enum.map(&String.trim/1)
          |> Enum.reject(&(&1 in ["", "no other"]))
          |> Enum.into(%{}, fn can_contain ->
            {int, bag_name} = Integer.parse(can_contain)

            {String.trim(bag_name), int}
          end)

        {bag_name, new_contains}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      Enum.count(input, &can_contain?(input, &1, "shiny gold"))
    end

    part_2 fn input ->
      count_bags_inside(input, input["shiny gold"])
    end
  end

  def count_bags_inside(input, rules) do
    rules
    |> Enum.map(fn {bag_name, count} ->
      if count == 0 do
        0
      else
        count + count * count_bags_inside(input, input[bag_name])
      end
    end)
    |> Enum.sum()
  end

  defp can_contain?(_input, {_bag_name, contains}, _target) when contains == %{}, do: false

  defp can_contain?(input, {_bag_name, contains}, target) do
    case Map.fetch(contains, target) do
      {:ok, count} when is_integer(count) ->
        count >= 1

      _ ->
        Enum.any?(contains, fn {bag, _count} ->
          can_contain?(input, {bag, Map.get(input, bag)}, target)
        end)
    end
  end
end
