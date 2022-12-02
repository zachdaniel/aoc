defmodule Aoc.Y2021.Day18 do
  use Aoc.Day

  answers do
    part_1 3574
    part_2 4763
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        {snail_number, ""} = parse_snail_number(line)
        snail_number
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> sum_snail_numbers()
      |> magnitude()
    end

    part_2 &find_highest_magnitude_of_adding_two_numbers/1
  end

  def parse_snail_number(<<number>> <> remaining)
      when number in [?0, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9] do
    {String.to_integer(<<number>>), remaining}
  end

  def parse_snail_number("[" <> remaining) do
    {first, "," <> remaining} = parse_snail_number(remaining)
    {second, "]" <> remaining} = parse_snail_number(remaining)
    {{first, second}, remaining}
  end

  defp find_highest_magnitude_of_adding_two_numbers(numbers) do
    for first <- numbers, second <- numbers, reduce: 0 do
      acc ->
        first_to_second = first |> add_snail_numbers(second) |> magnitude()

        second_to_first = second |> add_snail_numbers(first) |> magnitude

        max(acc, max(first_to_second, second_to_first))
    end
  end

  defp magnitude({left, right}), do: magnitude(left) * 3 + magnitude(right) * 2

  defp magnitude(value) when is_integer(value), do: value

  defp sum_snail_numbers([first_snail_number | rest_snail_numbers]) do
    Enum.reduce(rest_snail_numbers, first_snail_number, &add_snail_numbers(&2, &1))
  end

  defp add_snail_numbers(left, right) do
    {left, right}
    |> reduce_snail_number()
  end

  defp reduce_snail_number(number) do
    case find_explosion_path(number) do
      {:ok, explosion_path} ->
        new_number = explode(number, explosion_path)
        reduce_snail_number(new_number)

      :error ->
        case find_split(number) do
          {:ok, split_path} ->
            new_number = split(number, split_path)
            reduce_snail_number(new_number)

          :error ->
            number
        end
    end
  end

  defp explode(number, path) do
    {left, right} = get_number(number, path)

    number
    |> add_to_left_of(path, left)
    |> add_to_right_of(path, right)
    |> put_number(path, 0)
  end

  defp split(number, path) do
    update_number(number, path, fn number ->
      half = div(number, 2)

      {half, half + rem(number, 2)}
    end)
  end

  defp add_to_right_of(number, path, value) do
    path
    |> Enum.reverse()
    |> Enum.drop_while(&(&1 != 0))
    |> Enum.reverse()
    |> case do
      [] ->
        number

      path ->
        first_number_to_right =
          path
          |> :lists.droplast()
          |> Kernel.++([1])

        update_number(number, first_number_to_right, &add_to_leftmost_number(&1, value))
    end
  end

  defp add_to_left_of(number, path, value) do
    path
    |> Enum.reverse()
    |> Enum.drop_while(&(&1 != 1))
    |> Enum.reverse()
    |> case do
      [] ->
        number

      path ->
        first_number_to_left =
          path
          |> :lists.droplast()
          |> Kernel.++([0])

        update_number(number, first_number_to_left, &add_to_rightmost_number(&1, value))
    end
  end

  defp add_to_rightmost_number(number, value) when is_integer(number) do
    number + value
  end

  defp add_to_rightmost_number({left, right}, value) do
    {left, add_to_rightmost_number(right, value)}
  end

  defp add_to_leftmost_number(number, value) when is_integer(number) do
    number + value
  end

  defp add_to_leftmost_number({left, right}, value) do
    {add_to_leftmost_number(left, value), right}
  end

  defp update_number(number, [], func), do: func.(number)

  defp update_number({left, right}, [0 | rest], func),
    do: {update_number(left, rest, func), right}

  defp update_number({left, right}, [1 | rest], func),
    do: {left, update_number(right, rest, func)}

  defp put_number(_number, [], value), do: value

  defp put_number({left, right}, [0 | rest], value),
    do: {put_number(left, rest, value), right}

  defp put_number({left, right}, [1 | rest], value),
    do: {left, put_number(right, rest, value)}

  defp get_number(number, []), do: number
  defp get_number({left, _right}, [0 | rest]), do: get_number(left, rest)
  defp get_number({_left, right}, [1 | rest]), do: get_number(right, rest)

  defp find_explosion_path(number, trail \\ [])

  defp find_explosion_path(number, trail) when length(trail) == 4 and is_tuple(number),
    do: {:ok, Enum.reverse(trail)}

  defp find_explosion_path({left, right}, trail) do
    case find_explosion_path(left, [0 | trail]) do
      {:ok, explosion} ->
        {:ok, explosion}

      :error ->
        find_explosion_path(right, [1 | trail])
    end
  end

  defp find_explosion_path(_number, _trail), do: :error

  defp find_split(number, trail \\ [])

  defp find_split(number, trail) when is_integer(number) and number >= 10,
    do: {:ok, Enum.reverse(trail)}

  defp find_split({left, right}, trail) do
    case find_split(left, [0 | trail]) do
      {:ok, split} ->
        {:ok, split}

      :error ->
        find_split(right, [1 | trail])
    end
  end

  defp find_split(_, _), do: :error
end
