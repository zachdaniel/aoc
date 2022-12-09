defmodule Aoc.Y2022.Day9 do
  use Aoc.Day

  answers do
    part_1 6314
  end

  input do

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.flat_map(fn instruction ->
        [direction, number] = instruction |> String.split(" ")

        for _ <- 1..(String.to_integer(number)) do
          direction
        end
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new()}, fn dir, {head, tail, visited} ->

        head = move(head, dir)
        tail = follow(head, tail)

        {head, tail, MapSet.put(visited, tail)}
      end)
      |> elem(2)
      |> MapSet.size()
    end

    part_2 fn input ->
      tails =
        for _ <- 1..9 do
          {0, 0}
        end

      input
      |> Enum.reduce({{0, 0}, tails, MapSet.new([{0, 0}])}, fn dir, {head, tails, visited} ->
        head = move(head, dir)

        {last_visited, new_tails} =
          Enum.reduce(tails, {head, []}, fn tail, {prev, tails} ->
            res = follow(prev, tail)
            {res, [res | tails]}
          end)

        {head, Enum.reverse(new_tails), MapSet.put(visited, last_visited)}
      end)
      |> elem(2)
      |> MapSet.size()
    end
  end

  defp move({x, y}, "R"), do: {x + 1, y}
  defp move({x, y}, "L"), do: {x - 1, y}
  defp move({x, y}, "U"), do: {x, y + 1}
  defp move({x, y}, "D"), do: {x, y - 1}

  defp follow(head, tail) do
    if adjacent?(head, tail) do
      tail
    else
      do_follow(head, tail)
    end
  end

  defp adjacent?(head, head), do: true

  defp adjacent?({head_x, head_y}, {tail_x, tail_y}) do
    abs(head_x - tail_x) <= 1 && abs(head_y - tail_y) <= 1
  end

  defp do_follow({head_x, head_y}, {head_x, tail_y}) when head_y > tail_y do
    {head_x, tail_y + 1}
  end

  defp do_follow({head_x, head_y}, {head_x, tail_y}) when head_y < tail_y do
    {head_x, tail_y - 1}
  end

  defp do_follow({head_x, head_y}, {tail_x, head_y}) when head_x > tail_x do
    {tail_x + 1, head_y}
  end

  defp do_follow({head_x, head_y}, {tail_x, head_y}) when head_x < tail_x do
    {tail_x - 1, head_y}
  end

  defp do_follow({head_x, head_y}, {tail_x, tail_y}) do
    {close_in_on(head_x, tail_x), close_in_on(head_y, tail_y)}
  end

  defp do_follow(_, tail), do: tail

  defp close_in_on(l, r) do
    if l > r do
      r + 1
    else
      r - 1
    end
  end
end
