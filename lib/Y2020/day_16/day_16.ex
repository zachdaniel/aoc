defmodule Aoc.Y2020.Day16 do
  use Aoc.Day

  @input File.read!(Path.expand(Path.join(__DIR__, "input.txt")))

  [field_rules, your_ticket, nearby_tickets] = String.split(@input, "\n\n")

  @your_ticket your_ticket
               |> String.trim_leading("your ticket:\n")
               |> String.split(",")
               |> Enum.map(&String.to_integer/1)

  @nearby_tickets nearby_tickets
                  |> String.trim_leading("nearby tickets:\n")
                  |> String.split("\n")
                  |> Enum.map(fn ticket ->
                    ticket
                    |> String.split(",")
                    |> Enum.map(&String.to_integer/1)
                  end)

  defmodule Rules do
    @field_rules field_rules
                 |> String.split("\n")
                 |> Enum.map(fn rule ->
                   [field, rules] = String.split(rule, ": ")
                   [left_range, right_range] = String.split(rules, " or ")
                   [left_range_start, left_range_end] = String.split(left_range, "-")
                   [right_range_start, right_range_end] = String.split(right_range, "-")

                   {field,
                    {String.to_integer(left_range_start), String.to_integer(left_range_end)},
                    {String.to_integer(right_range_start), String.to_integer(right_range_end)}}
                 end)

    @fields @field_rules |> Enum.map(&elem(&1, 0))

    def fields, do: @fields

    for {field, {left_start, left_end}, {right_start, right_end}} <- @field_rules do
      @left_start left_start
      @left_end left_end
      @right_start right_start
      @right_end right_end
      @field field
      def match?(:any, value) when value in @left_start..@left_end, do: true
      def match?(@field, value) when value in @left_start..@left_end, do: true
      def match?(:any, value) when value in @right_start..@right_end, do: true
      def match?(@field, value) when value in @right_start..@right_end, do: true
    end

    def match?(_, _), do: false
  end

  answers do
    part_1 18227
    part_2 2_355_350_878_831
  end

  solutions do
    part_1 fn _input ->
      @nearby_tickets
      |> Enum.flat_map(fn nearby_ticket ->
        Enum.reject(nearby_ticket, &Rules.match?(:any, &1))
      end)
      |> Enum.sum()
    end

    part_2 fn _input ->
      valid_tickets =
        Enum.filter(@nearby_tickets, fn nearby_ticket ->
          Enum.all?(nearby_ticket, &Rules.match?(:any, &1))
        end)

      fields = Rules.fields()
      count = Enum.count(fields)
      field_positions = determine_field_positions(fields, count, valid_tickets)

      field_positions
      |> Enum.filter(fn
        {"departure" <> _, _val} ->
          true

        _ ->
          false
      end)
      |> Enum.map(fn {_key, index} ->
        Enum.at(@your_ticket, index)
      end)
      |> Enum.reduce(&Kernel.*/2)
    end
  end

  defp determine_field_positions(fields, count, valid_tickets, acc \\ %{})
  defp determine_field_positions([], _, _, acc), do: acc

  defp determine_field_positions([field | rest] = fields, count, valid_tickets, acc) do
    case find_requirement(fields, acc) do
      {:requirement, new_fields, acc} ->
        determine_field_positions(new_fields, count, valid_tickets, acc)

      _ ->
        {indices, field} =
          case field do
            {indices, field} ->
              {indices, field}

            field ->
              {0..count, field}
          end

        indices
        |> Enum.filter(fn index ->
          could_match?(field, index, valid_tickets)
        end)
        |> case do
          [index] ->
            determine_field_positions(rest, count, valid_tickets, Map.put(acc, field, index))

          indices ->
            determine_field_positions(rest ++ [{indices, field}], count, valid_tickets, acc)
        end
    end
  end

  defp find_requirement(fields, acc) do
    if Enum.all?(fields, &is_tuple/1) do
      fields
      |> Enum.reduce(%{}, fn {indices, field}, acc ->
        Enum.reduce(indices, acc, fn index, acc ->
          Map.update(acc, index, [field], &Kernel.++(&1, [field]))
        end)
      end)
      |> Enum.find(fn {_key, val} ->
        Enum.count(val) == 1
      end)
      |> case do
        nil ->
          nil

        {index, [field]} ->
          new_fields =
            fields
            |> Enum.reject(fn {_, val} -> val == field end)
            |> Enum.map(fn {indices, val} ->
              {indices -- [index], val}
            end)

          {:requirement, new_fields, Map.put(acc, field, index)}
      end
    end
  end

  defp could_match?(field, index, valid_tickets) do
    Enum.all?(valid_tickets, fn valid_ticket ->
      Rules.match?(field, Enum.at(valid_ticket, index))
    end)
  end
end
