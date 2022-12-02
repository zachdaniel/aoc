defmodule Aoc.Y2020.Day13 do
  use Aoc.Day

  answers do
    part_1 4938
    part_2 230_903_629_977_901
  end

  input do
    handle_input fn input ->
      input = String.split(input, "\n")
      earliest_departure = input |> Enum.at(0) |> String.to_integer()

      in_service_busses =
        input
        |> Enum.at(1)
        |> String.split(",")
        |> Enum.reject(&(&1 == "x"))
        |> Enum.map(&String.to_integer/1)

      all_busses =
        input
        |> Enum.at(1)
        |> String.split(",")
        |> Enum.with_index()
        |> Enum.reject(fn {elem, _} -> elem == "x" end)
        |> Enum.map(fn {elem, i} ->
          {String.to_integer(elem), i}
        end)
        |> Enum.sort_by(&elem(&1, 0))

      %{
        input: input,
        earliest_departure: earliest_departure,
        in_service_busses: in_service_busses,
        all_busses: all_busses
      }
    end
  end

  solutions do
    part_1 fn input ->
      {id, minutes} =
        input.in_service_busses
        |> Enum.map(&{&1, earliest_departure_time(&1, input.earliest_departure)})
        |> Enum.min_by(&elem(&1, 1))

      id * (minutes - input.earliest_departure)
    end

    part_2 fn input ->
      search(input.all_busses, 1, 1)
    end
  end

  defp search([], tick, _), do: tick

  defp search(input, tick, factor) do
    match =
      Enum.find_index(input, fn {elem, i} ->
        rem(tick + i, elem) == 0
      end)

    case match do
      nil ->
        search(input, tick + factor, factor)

      match ->
        {bus, _i} = Enum.at(input, match)

        search(List.delete_at(input, match), tick, factor * bus)
    end
  end

  defp earliest_departure_time(bus, earliest_departure, init \\ nil) do
    if bus >= earliest_departure do
      bus
    else
      init = init || bus
      earliest_departure_time(bus + init, earliest_departure, init)
    end
  end
end
