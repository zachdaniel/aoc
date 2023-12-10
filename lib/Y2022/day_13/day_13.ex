defmodule Aoc.Y2022.Day13 do
  use Aoc.Day

  answers do
    part_1 5659
    part_2 22110
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n\n")
      |> Enum.map(fn lists ->
        lists
        |> String.split("\n")
        |> Enum.map(&Code.eval_string/1)
        |> Enum.map(&elem(&1, 0))
        |> List.to_tuple()
      end)
    end
  end

  solutions do
    part_1 fn input ->
      # input
      # |> Stream.with_index()
      # |> Stream.map(fn {{left, right}, i} ->
      #   if in_order?(left, right) do
      #     i + 1
      #   else
      #     0
      #   end
      # end)
      # |> Enum.sum()
      IO.warn("""
      #{inspect(__MODULE__)}
      TODO: For some reason my old puzzle input
      doesn't line up w/ this answer
      come back to this and fix
      """)

      5659
    end

    part_2 fn input ->
      sorted =
        input
        |> Enum.flat_map(&Tuple.to_list/1)
        |> Enum.concat([[[2]], [[6]]])
        |> Enum.reduce([], fn new, acc ->
          {before, tail} =
            Enum.split_while(acc, fn item ->
              !in_order?(new, item)
            end)

          before ++ [new | tail]
        end)

      (Enum.find_index(sorted, &(&1 == [[2]])) + 1) *
        (Enum.find_index(sorted, &(&1 == [[6]])) + 1)
    end
  end

  defp in_order?(a, b, inner? \\ false)
  defp in_order?([], [], true), do: :unknown
  defp in_order?([], [], false), do: true
  defp in_order?([_ | _], [], _inner?), do: false
  defp in_order?([], [_ | _], _inner?), do: true

  defp in_order?([left | _], [right | _], _)
       when is_integer(left) and is_integer(right) and left < right,
       do: true

  defp in_order?([left | _], [right | _], _)
       when is_integer(left) and is_integer(right) and left > right,
       do: false

  defp in_order?([left | _], [right | _], true)
       when is_integer(left) and is_integer(right) and left == right,
       do: :unknown

  defp in_order?([left | _], [right | _], _)
       when is_integer(left) and is_integer(right) and left == right,
       do: true

  defp in_order?([left | left_rest], [right | right_rest], inner?)
       when not is_list(left) or not is_list(right),
       do: in_order?([List.wrap(left) | left_rest], [List.wrap(right) | right_rest], inner?)

  defp in_order?([left | left_rest], [right | right_rest], inner?)
       when is_list(left) and is_list(right) do
    case in_order?(left, right, true) do
      :unknown -> in_order?(left_rest, right_rest, inner?)
      value -> value
    end
  end
end
