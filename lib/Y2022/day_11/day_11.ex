defmodule Aoc.Y2022.Day11 do
  use Aoc.Day

  answers do
    part_1 55458
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {text, monkey} ->
        [
          _,
          "  Starting items: " <> starting_items,
          "  Operation: new = " <> operation,
          "  Test: divisible by " <> divisible_by,
          "    If true: throw to monkey " <> throw_to_if_true,
          "    If false: throw to monkey " <> throw_to_if_false
        ] = String.split(text, "\n")

        starting_items =
          starting_items
          |> String.split(", ")
          |> Enum.map(&String.to_integer/1)

        [left, op, right] =
          operation
          |> String.split(" ")
          |> Enum.map(fn
            "old" ->
              :old

            v ->
              case Integer.parse(v) do
                {int, ""} ->
                  int

                _ ->
                  String.to_atom(v)
              end
          end)

        throw_to_if_false = String.to_integer(throw_to_if_false)
        throw_to_if_true = String.to_integer(throw_to_if_true)

        {monkey,
         %{
           inspect_count: 0,
           items: starting_items,
           divisible_by: String.to_integer(divisible_by),
           operation: {left, op, right},
           if_false: throw_to_if_false,
           if_true: throw_to_if_true
         }}
      end)
      |> Map.new()
    end
  end

  solutions do
    part_1 fn input ->
      monkey_count = Enum.count(input) - 1

      input
      |> play_rounds(20, monkey_count, true)
      |> Enum.map(fn {_key, value} ->
        value[:inspect_count]
      end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(2)
      |> Enum.reduce(&Kernel.*/2)
    end

    part_2 fn input ->
      monkey_count = Enum.count(input) - 1
      lcm = lcm(Enum.map(input, fn {_, %{divisible_by: divisible_by}} -> divisible_by end))

      input
      |> play_rounds(10000, monkey_count, false, lcm)
      |> minimize(lcm)
      |> Enum.map(fn {_key, value} ->
        value[:inspect_count]
      end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(2)
      |> Enum.reduce(&Kernel.*/2)
    end
  end

  defp play_rounds(input, rounds, monkey_count, div_3?, lcm \\ nil)
  defp play_rounds(input, 0, _, _div_3?, _lcm), do: input

  defp play_rounds(input, rounds, monkey_count, div_3?, lcm) do
    input = minimize(input, lcm)

    0..monkey_count
    |> Enum.reduce(input, &take_turn(&1, &2, div_3?))
    |> play_rounds(rounds - 1, monkey_count, div_3?, lcm)
  end

  defp minimize(data, nil), do: data

  defp minimize(data, lcm) do
    Enum.reduce(data, data, fn {key, _value}, monkeys ->
      Map.update!(monkeys, key, fn data ->
        data
        |> Map.update!(:items, fn items ->
          Enum.map(items, fn item ->
            rem(item, lcm)
          end)
        end)
      end)
    end)
  end

  defp take_turn(monkey, data, div_3?) do
    %{
      items: items,
      operation: operation,
      if_false: throw_to_if_false,
      divisible_by: divisible_by,
      if_true: throw_to_if_true
    } = data[monkey]

    items
    |> Enum.reduce(data, fn item, data ->
      data =
        Map.update!(data, monkey, fn monkey ->
          Map.update!(monkey, :inspect_count, &(&1 + 1))
        end)

      new_item = apply_operation(item, operation)

      new_item =
        if div_3? do
          div(new_item, 3)
        else
          new_item
        end

      if rem(new_item, divisible_by) == 0 do
        throw_to(data, monkey, throw_to_if_true, new_item)
      else
        throw_to(data, monkey, throw_to_if_false, new_item)
      end
    end)
  end

  defp throw_to(data, from, to, new_item) do
    data
    |> Map.update!(from, fn from ->
      Map.update!(from, :items, &Enum.drop(&1, 1))
    end)
    |> Map.update!(to, fn to ->
      Map.update!(to, :items, &(&1 ++ [new_item]))
    end)
  end

  defp apply_operation(item, {left, op, right}) do
    left =
      case left do
        :old -> item
        v -> v
      end

    right =
      case right do
        :old -> item
        v -> v
      end

    apply(Kernel, op, [left, right])
  end
end
