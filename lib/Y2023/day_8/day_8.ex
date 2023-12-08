defmodule Aoc.Y2023.Day8 do
  use Aoc.Day

  answers do
    part_1 14893
  end

  input do
    use_example? false

    handle_input fn input ->
      [directions, _ | rest] =
        input
        |> String.split("\n")

      directions = String.graphemes(directions)

      map =
        Enum.reduce(rest, %{}, fn line, acc ->
          [target, left, right] = String.split(line, [" = (", ", ", ")"], trim: true)
          Map.put(acc, target, %{left: left, right: right})
        end)

      %{directions: directions, map: map}
    end
  end

  solutions do
    part_1 fn input ->
      go_to(input, input.directions, "AAA", "ZZZ")
    end

    part_2 fn input ->
      input.map
      |> Map.keys()
      |> Enum.filter(&String.ends_with?(&1, "A"))
      |> Enum.map(fn start ->
        go_to(input, input.directions, start, &String.ends_with?(&1, "Z"))
      end)
      |> lcm()
    end
  end

  defp go_to(input, directions, start, finish) do
    directions
    |> Enum.with_index()
    |> Stream.cycle()
    |> Enum.reduce_while({start, 0, true}, fn
      {_, 0}, {^start, _, false} ->
        {:halt, nil}

      _, {^finish, count, _} when not is_function(finish) ->
        {:halt, count}

      {"R", _}, {current, count, _} ->
        if is_function(finish) && finish.(current) do
          {:halt, count}
        else
          {:cont, {Map.get(input.map, current).right, count + 1, false}}
        end

      {"L", _}, {current, count, _} ->
        if is_function(finish) && finish.(current) do
          {:halt, count}
        else
          {:cont, {Map.get(input.map, current).left, count + 1, false}}
        end
    end)
  end
end
