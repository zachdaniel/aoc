defmodule Aoc.Y2020.Day14 do
  use Aoc.Day

  answers do
    part_1 6_559_449_933_360
    part_2 3_369_767_240_513
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn
        "mask = " <> mask ->
          {:set_mask, mask |> String.graphemes()}

        str ->
          str = String.trim_leading(str, "mem[")
          {address, str} = Integer.parse(str)
          str = String.trim_leading(str, "] = ")
          value = String.to_integer(str)

          {address, value}
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> follow_instructions(%{})
      |> Map.values()
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> follow_v2_instructions(%{})
      |> Map.values()
      |> Enum.sum()
    end
  end

  defp follow_v2_instructions(instructions, mem, mask \\ nil)
  defp follow_v2_instructions([], mem, _), do: mem

  defp follow_v2_instructions([{:set_mask, new_mask} | rest], mem, _mask) do
    follow_v2_instructions(rest, mem, new_mask)
  end

  defp follow_v2_instructions([{addr, val} | rest], mem, mask) do
    new_mem =
      addr
      |> apply_bitmask_with_floating_bits(mask)
      |> Enum.reduce(mem, fn addr, mem ->
        Map.put(mem, addr, val)
      end)

    follow_v2_instructions(rest, new_mem, mask)
  end

  defp apply_bitmask_with_floating_bits(val, mask) do
    val
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.zip(mask)
    |> possible_futures()
    |> Enum.map(fn future ->
      future
      |> Enum.join()
      |> String.reverse()
      |> String.to_integer(2)
    end)
  end

  defp possible_futures(bits, trail \\ [])

  defp possible_futures([], trail), do: [[trail]]

  defp possible_futures([{val, "0"} | rest], trail) do
    possible_futures(rest, [val | trail])
  end

  defp possible_futures([{_val, "1"} | rest], trail) do
    possible_futures(rest, ["1" | trail])
  end

  defp possible_futures([{_, "X"} | rest], trail) do
    possible_futures(rest, ["0" | trail]) ++ possible_futures(rest, ["1" | trail])
  end

  defp follow_instructions(instructions, mem, mask \\ nil)
  defp follow_instructions([], mem, _), do: mem

  defp follow_instructions([{:set_mask, new_mask} | rest], mem, _mask) do
    follow_instructions(rest, mem, new_mask)
  end

  defp follow_instructions([{addr, val} | rest], mem, mask) do
    new_mem = Map.put(mem, addr, apply_bitmask(val, mask))

    follow_instructions(rest, new_mem, mask)
  end

  defp apply_bitmask(val, mask) do
    val
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> Enum.zip(mask)
    |> Enum.map(fn
      {val, "X"} ->
        val

      {_, mask_val} ->
        mask_val
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end
end
