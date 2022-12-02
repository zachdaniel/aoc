defmodule Aoc.Y2020.Day23 do
  use Aoc.Day

  defmodule State do
    @input __DIR__
           |> Path.expand()
           |> Path.join("input.txt")
           |> File.read!()
           |> String.graphemes()
           |> Enum.map(&String.to_integer/1)

    defstruct current_cup: Enum.at(@input, 0),
              cups:
                @input
                |> Enum.with_index()
                |> Map.new(fn {item, index} ->
                  {item, Enum.at(@input, index + 1) || Enum.at(@input, 0)}
                end)
                |> Map.put(List.last(@input), List.first(@input)),
              min: Enum.min(@input),
              max: Enum.max(@input),
              count: Enum.count(@input)

    def part_two() do
      input = Enum.concat(@input, 10..1_000_000)
      links = Enum.concat([Enum.drop(input, 1), [List.first(input)]])

      cups =
        input
        |> Enum.zip(links)
        |> Map.new(fn {item, link} -> {item, link} end)

      %__MODULE__{
        current_cup: Enum.at(@input, 0),
        cups: cups,
        min: 1,
        max: 1_000_000,
        count: 1_000_000
      }
    end
  end

  answers do
    part_1 89_573_246
    part_2 2_029_056_128
  end

  solutions do
    part_1 fn _ ->
      state = %State{}

      state
      |> move(100)
      |> Map.get(:cups)
      |> sequence(1)
      |> :lists.droplast()
      |> Enum.join("")
    end

    part_2 fn _ ->
      state = State.part_two()

      cups =
        state
        |> move(10_000_000)
        |> Map.get(:cups)

      first = Map.get(cups, 1)
      second = Map.get(cups, first)

      first * second
    end
  end

  defp sequence(empty, _) when empty == %{}, do: []

  defp sequence(cups, val) do
    {next_value, new_cups} = Map.pop(cups, val)
    [next_value | sequence(new_cups, next_value)]
  end

  defp move(state, 0), do: state

  defp move(%{cups: cups, current_cup: current_cup} = state, times) do
    three_cups = three_cups_to_the_right(cups, current_cup)

    current_cup
    |> move_cups(three_cups, state)
    |> move(times - 1)
  end

  defp move_cups(current_cup, three_cups, %{cups: cups, max: max} = state) do
    destination_cup =
      if current_cup == 1 do
        Enum.find(max..1, &(&1 not in three_cups))
      else
        case Enum.find((current_cup - 1)..1, &(&1 not in three_cups)) do
          nil ->
            Enum.find(max..1, &(&1 not in three_cups))

          cup ->
            cup
        end
      end

    new_cups =
      cups
      |> Map.put(destination_cup, Enum.at(three_cups, 0))
      |> Map.put(List.last(three_cups), Map.get(cups, destination_cup))
      |> Map.put(current_cup, Map.get(cups, List.last(three_cups)))

    %{state | cups: new_cups, current_cup: Map.get(new_cups, current_cup)}
  end

  defp three_cups_to_the_right(cups, target) do
    first = Map.get(cups, target)
    second = Map.get(cups, first)
    third = Map.get(cups, second)
    [first, second, third]
  end
end
