defmodule Aoc.Y2023.Day6 do
  use Aoc.Day

  answers do
    part_1 2_756_160
    part_2 34_788_142
  end

  input do
    use_example? false

    handle_input fn input ->
      ["Time: " <> times, "Distance: " <> distances] = input |> String.split("\n")

      times =
        times
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)

      distances =
        distances
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)

      Enum.zip_with([times, distances], fn [time, distance] ->
        %{time: time, record_distance: distance}
      end)
    end

    handle_part_2_input fn input ->
      ["Time: " <> times, "Distance: " <> distances] = input |> String.split("\n")

      time =
        times
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.join()
        |> String.to_integer()

      distance =
        distances
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.join()
        |> String.to_integer()

      %{time: time, record_distance: distance}
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(&number_of_ways_to_beat_record/1)
      |> Enum.reduce(1, &Kernel.*/2)
    end

    part_2 fn input ->
      number_of_ways_to_beat_record(input)
    end
  end

  defp number_of_ways_to_beat_record(%{time: time, record_distance: record_distance}) do
    Enum.count(1..(time - 1), fn hold ->
      distance(hold, time) > record_distance
    end)
  end

  defp distance(hold, time) do
    seconds_left_to_travel = time - hold
    seconds_left_to_travel * hold
  end
end
