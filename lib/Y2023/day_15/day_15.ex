defmodule Aoc.Y2023.Day15 do
  use Aoc.Day

  answers do
    part_1 494_980
    part_2 247_933
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split(",")
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.map(&get_hash/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      boxes =
        Map.new(0..255, &{&1, []})

      input
      |> Enum.map(fn item ->
        operator =
          if String.contains?(item, "=") do
            "="
          else
            "-"
          end

        case operator do
          "-" ->
            label = String.trim_trailing(item, "-")
            box = get_hash(label)
            {:remove, box, label}

          "=" ->
            [label, focal_length] = String.split(item, "=", parts: 2, trim: true)
            box = get_hash(label)
            {:put, box, label, String.to_integer(focal_length)}
        end
      end)
      |> Enum.reduce(boxes, &apply_instruction/2)
      |> sum_focusing_power()
    end
  end

  defp sum_focusing_power(lenses) do
    lenses
    |> Enum.flat_map(fn {number, lenses} ->
      lenses
      |> Enum.with_index()
      |> Enum.map(fn {%{focal_length: focal_length}, index} ->
        (number + 1) * (index + 1) * focal_length
      end)
    end)
    |> Enum.sum()
  end

  defp apply_instruction({:remove, box, label}, boxes) do
    Map.update!(boxes, box, fn lenses ->
      Enum.reject(lenses, &(&1.label == label))
    end)
  end

  defp apply_instruction({:put, box, label, focal_length}, boxes) do
    Map.update!(boxes, box, fn lenses ->
      if Enum.any?(lenses, &(&1.label == label)) do
        Enum.map(lenses, fn lens ->
          if lens.label == label do
            %{lens | focal_length: focal_length}
          else
            lens
          end
        end)
      else
        lenses ++ [%{label: label, focal_length: focal_length}]
      end
    end)
  end

  defp get_hash(value, acc \\ 0)

  defp get_hash("", acc) do
    acc
  end

  defp get_hash(<<first::utf8>> <> rest, acc) do
    acc
    |> Kernel.+(first)
    |> Kernel.*(17)
    |> rem(256)
    |> then(&get_hash(rest, &1))
  end
end
