defmodule Aoc.Y2022.Day5 do
  use Aoc.Day

  answers do
    part_1 "JDTMRWCQJ"
    part_2 "VHJDDCWRD"
  end

  input do
    handle_input fn input ->
      [stacks, directions] = String.split(input, "\n\n")

      stack_rows =
        stacks
        |> String.split("\n")
        |> :lists.droplast()
        |> Enum.map(fn row ->
          String.graphemes(row)
          |> Enum.chunk_every(4)
          |> Enum.map(fn
            ["[", l, "]" | _] ->
              l

            _ ->
              nil
          end)
        end)

      cols =
        stack_rows
        |> Enum.zip()
        |> Enum.map(fn stack_row ->
          stack_row
          |> Tuple.to_list()
          |> Enum.reject(&is_nil/1)
        end)

      directions =
        directions
        |> String.split("\n")
        |> Enum.map(fn "move " <> direction ->
          {count, direction} = take_int(direction, "move ")
          {from, direction} = take_int(direction, "from ")
          {to, _direction} = take_int(direction, "to ")

          {count, from, to}
        end)

      %{cols: cols, directions: directions}
    end
  end

  solutions do
    part_1 fn input ->
      input.directions
      |> Enum.reduce(input.cols, fn {count, from, to}, cols ->
        move(cols, count, from, to)
      end)
      |> top_stacks()
    end

    part_2 fn input ->
      input.directions
      |> Enum.reduce(input.cols, fn {count, from, to}, cols ->
        move(cols, count, from, to, true)
      end)
      |> top_stacks()
    end
  end

  defp take_int(string, prefix) do
    string
    |> String.trim()
    |> String.trim_leading(prefix)
    |> Integer.parse()
  end

  defp move(cols, count, from, to, pick_up_multiple? \\ false) do
    i = from - 1
    col = Enum.at(cols, i)
    {removed, new_col} = Enum.split(col, count)

    cols
    |> List.replace_at(i, new_col)
    |> List.update_at(to - 1, fn current ->
      if pick_up_multiple? do
        removed ++ current
      else
        Enum.reverse(removed) ++ current
      end
    end)
  end

  defp top_stacks(stacks) do
    stacks |> Enum.map(&List.first/1) |> Enum.join()
  end
end
