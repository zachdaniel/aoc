defmodule Aoc.Y2023.Day1 do
  use Aoc.Day

  answers do
    part_1 56397
    part_2 55701
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(fn line ->
        nums =
          line
          |> String.graphemes()
          |> Enum.filter(&(&1 in ["1", "2", "3", "4", "5", "6", "7", "8", "9"]))

        first = List.first(nums)
        last = :lists.last(nums)

        "#{first}#{last}" |> String.to_integer()
      end)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Enum.map(fn line ->
        first =
          line
          |> replace_num()
          |> String.graphemes()
          |> Enum.filter(&(&1 in ["1", "2", "3", "4", "5", "6", "7", "8", "9"]))
          |> List.first()

        last =
          line
          |> replace_num(true)
          |> String.graphemes()
          |> Enum.filter(&(&1 in ["1", "2", "3", "4", "5", "6", "7", "8", "9"]))
          |> :lists.last()

        "#{first}#{last}" |> String.to_integer()
      end)
      |> Enum.sum()
    end
  end

  @nums ~w(one two three four five six seven eight nine)
        |> Enum.with_index()
        |> Enum.map(fn {num, index} -> {num, index + 1} end)
  @reversed_nums Enum.map(@nums, fn {num, index} -> {String.reverse(num), index} end)

  defp replace_num(string, reverse? \\ false) do
    if reverse? do
      string
      |> String.reverse()
      |> do_replace_nums(@reversed_nums)
      |> String.reverse()
    else
      do_replace_nums(string, @nums)
    end
  end

  defp do_replace_nums(string, nums) do
    nums
    |> Enum.flat_map(fn {num, index} ->
      position_of =
        string
        |> String.graphemes()
        |> Enum.chunk_every(String.length(num), 1)
        |> Enum.find_index(&(&1 == String.graphemes(num)))

      if position_of do
        [{num, index, position_of}]
      else
        []
      end
    end)
    |> case do
      [] ->
        string

      nums ->
        {num, index, _} =
          Enum.min_by(nums, &elem(&1, 2))

        String.replace(string, to_string(num), to_string(index))
    end
  end
end
