defmodule Aoc.Y2020.Day12 do
  use Aoc.Day

  answers do
    part_1 796
    part_2 39446
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn str ->
        {instruction, magnitude} = String.split_at(str, 1)
        {instruction, String.to_integer(magnitude)}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> follow_old_instructions()
      |> manhattan_distance()
    end

    part_2 fn input ->
      input
      |> follow_instructions
      |> manhattan_distance()
    end
  end

  defp manhattan_distance(%{east: east, north: north}), do: abs(east) + abs(north)

  defp follow_instructions(
         instructions,
         acc \\ %{
           direction: :east,
           east: 0,
           north: 0,
           waypoint: %{
             east: 10,
             north: 1
           }
         }
       )

  defp follow_instructions([], acc), do: acc

  defp follow_instructions([instruction | rest], acc) do
    new_acc = follow_instruction(instruction, acc)

    follow_instructions(rest, new_acc)
  end

  defp follow_instruction({"N", amount}, acc),
    do: %{acc | waypoint: move(acc.waypoint, :north, amount)}

  defp follow_instruction({"S", amount}, acc),
    do: %{acc | waypoint: move(acc.waypoint, :south, amount)}

  defp follow_instruction({"E", amount}, acc),
    do: %{acc | waypoint: move(acc.waypoint, :east, amount)}

  defp follow_instruction({"W", amount}, acc),
    do: %{acc | waypoint: move(acc.waypoint, :west, amount)}

  defp follow_instruction({"L", amount}, acc),
    do: %{acc | waypoint: rotate_waypoint(acc.waypoint, :left, amount)}

  defp follow_instruction({"R", amount}, acc),
    do: %{acc | waypoint: rotate_waypoint(acc.waypoint, :right, amount)}

  defp follow_instruction({"F", amount}, acc),
    do: %{
      acc
      | east: acc.east + acc.waypoint.east * amount,
        north: acc.north + acc.waypoint.north * amount
    }

  defp follow_old_instructions(instructions, acc \\ %{direction: :east, east: 0, north: 0})

  defp follow_old_instructions([], acc) do
    acc
  end

  defp follow_old_instructions([instruction | rest], acc) do
    new_acc = follow_old_instruction(instruction, acc)

    follow_old_instructions(rest, new_acc)
  end

  defp follow_old_instruction({"N", amount}, acc), do: move(acc, :north, amount)
  defp follow_old_instruction({"S", amount}, acc), do: move(acc, :south, amount)
  defp follow_old_instruction({"E", amount}, acc), do: move(acc, :east, amount)
  defp follow_old_instruction({"W", amount}, acc), do: move(acc, :west, amount)

  defp follow_old_instruction({"L", amount}, acc),
    do: %{acc | direction: turn(acc.direction, :left, amount)}

  defp follow_old_instruction({"R", amount}, acc),
    do: %{acc | direction: turn(acc.direction, :right, amount)}

  defp follow_old_instruction({"F", amount}, acc), do: move(acc, acc.direction, amount)

  defp rotate_waypoint(data, _, 0), do: data

  defp rotate_waypoint(data, :right, amount) do
    rotate_waypoint(%{data | north: -data.east, east: data.north}, :right, amount - 90)
  end

  defp rotate_waypoint(data, :left, amount) do
    rotate_waypoint(%{data | north: data.east, east: -data.north}, :left, amount - 90)
  end

  defp move(data, :north, amount), do: %{data | north: data.north + amount}
  defp move(data, :south, amount), do: %{data | north: data.north - amount}
  defp move(data, :east, amount), do: %{data | east: data.east + amount}
  defp move(data, :west, amount), do: %{data | east: data.east - amount}

  defp turn(direction, _, 0), do: direction
  defp turn(:west, :right, value), do: turn(:north, :right, value - 90)
  defp turn(:west, :left, value), do: turn(:south, :left, value - 90)
  defp turn(:south, :right, value), do: turn(:west, :right, value - 90)
  defp turn(:south, :left, value), do: turn(:east, :left, value - 90)
  defp turn(:east, :right, value), do: turn(:south, :right, value - 90)
  defp turn(:east, :left, value), do: turn(:north, :left, value - 90)
  defp turn(:north, :right, value), do: turn(:east, :right, value - 90)
  defp turn(:north, :left, value), do: turn(:west, :left, value - 90)
end
