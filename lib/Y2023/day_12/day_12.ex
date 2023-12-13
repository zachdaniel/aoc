defmodule Aoc.Y2023.Day12 do
  use Aoc.Day
  use Nebulex.Caching

  answers do
    part_1 7705
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        [line | numbers] = String.split(line, [" ", ","])

        springs =
          line
          |> String.graphemes()
          |> Enum.map(fn
            "#" ->
              :damaged

            "." ->
              :operational

            "?" ->
              :unknown
          end)

        %{springs: springs, numbers: Enum.map(numbers, &String.to_integer/1)}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      Aoc.Cache.start_link()

      input
      |> Enum.map(&ways_to_arrange/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      Aoc.Cache.start_link()

      input
      |> Stream.map(&unfold/1)
      |> Stream.map(&ways_to_arrange/1)
      |> Enum.sum()
    end
  end

  defp ways_to_arrange(%{springs: springs, numbers: numbers}) do
    do_ways_to_arrange(springs, numbers, :operational)
  end

  defp do_ways_to_arrange([], [], _), do: 1

  defp do_ways_to_arrange([], [0], _), do: 1

  defp do_ways_to_arrange([], _, _), do: 0

  defp do_ways_to_arrange([:damaged | _], [], _), do: 0

  defp do_ways_to_arrange([:damaged | _], [0 | _], _), do: 0

  defp do_ways_to_arrange([:damaged | springs], [number | numbers], _),
    do: do_ways_to_arrange(springs, [number - 1 | numbers], :damaged)

  defp do_ways_to_arrange([:operational | springs], [], _),
    do: do_ways_to_arrange(springs, [], :operational)

  defp do_ways_to_arrange([:operational | springs], [0 | numbers], :damaged),
    do: do_ways_to_arrange(springs, numbers, :operational)

  defp do_ways_to_arrange([:operational | _], [_ | _], :damaged), do: 0

  defp do_ways_to_arrange([:operational | springs], numbers, :operational),
    do: do_ways_to_arrange(springs, numbers, :operational)

  defp do_ways_to_arrange([:unknown | springs], [], :damaged),
    do: do_ways_to_arrange(springs, [], :operational)

  defp do_ways_to_arrange([:unknown | springs], [0 | numbers], :damaged),
    do: do_ways_to_arrange(springs, numbers, :operational)

  defp do_ways_to_arrange([:unknown | springs], [number | numbers], :damaged),
    do: do_ways_to_arrange(springs, [number - 1 | numbers], :damaged)

  defp do_ways_to_arrange([:unknown | springs], [], :operational),
    do: do_ways_to_arrange(springs, [], :operational)

  defp do_ways_to_arrange([:unknown | springs], [0 | numbers], :operational),
    do: do_ways_to_arrange(springs, numbers, :operational)

  @decorate cacheable(cache: Aoc.Cache, key: {springs, number, numbers})
  defp do_ways_to_arrange([:unknown | springs], [number | numbers] = all_numbers, _) do
    do_ways_to_arrange(springs, all_numbers, :operational) +
      do_ways_to_arrange(springs, [number - 1 | numbers], :damaged)
  end

  defp unfold(%{springs: springs, numbers: numbers}) do
    %{
      springs: springs |> Stream.duplicate(5) |> Enum.intersperse([:unknown]) |> Enum.concat(),
      numbers: numbers |> Stream.duplicate(5) |> Enum.concat()
    }
  end
end
