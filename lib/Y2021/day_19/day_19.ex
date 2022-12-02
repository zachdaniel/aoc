defmodule Aoc.Y2021.Day19 do
  use Aoc.Day

  defmodule Scanner do
    defstruct [
      :index,
      :points,
      :location,
      :rotation,
      :facing,
      :negative?,
      :transform,
      :mask
    ]
  end

  answers do
    part_1 512
    part_2 16802
  end

  input do
    handle_input fn input ->
      input
      |> String.split(~r/--- scanner \d+ ---\n/, trim: true)
      |> Enum.map(&parse_scanner/1)
      |> Enum.with_index()
      |> Enum.map(fn {points, index} ->
        if index == 0 do
          %Scanner{
            index: index,
            points: points,
            location: {0, 0, 0},
            transform: {0, 0, 0},
            facing: :x,
            rotation: 0,
            negative?: false,
            mask: & &1
          }
        else
          %Scanner{index: index, points: points}
        end
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> build_scanner_map()
      |> Enum.flat_map(& &1.points)
      |> Enum.uniq()
      |> Enum.count()
    end

    part_2 fn input ->
      transforms =
        input
        |> build_scanner_map()
        |> Enum.map(& &1.transform)

      transforms
      |> Enum.reduce(0, fn transform1, max ->
        Enum.reduce(transforms, max, fn transform2, max ->
          max(manhattan_distance(transform1, transform2), max)
        end)
      end)
    end
  end

  defp parse_scanner(scanner) do
    scanner
    |> String.split("\n", trim: true)
    |> Enum.map(fn scanner ->
      scanner
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp manhattan_distance({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end

  def build_scanner_map(scanners) do
    [first | rest] = scanners

    do_build_scanner_map([first], rest)
  end

  defp do_build_scanner_map(scanners, []), do: scanners

  defp do_build_scanner_map(scanners, remaining_scanners) do
    aligned_scanner = align_one_scanner(scanners, remaining_scanners)

    # IO.inspect("locked in #{aligned_scanner.index}")
    new_remaining_scanners = Enum.reject(remaining_scanners, &(&1.index == aligned_scanner.index))

    do_build_scanner_map([aligned_scanner | scanners], new_remaining_scanners)
  end

  defp transform(scanner) do
    %{
      scanner
      | points: Enum.map(scanner.points, fn point -> add_mask(point, scanner.transform) end)
    }
  end

  defp align_one_scanner(scanners, [scanner | remaining_scanners]) do
    case align_scanner(scanners, scanner) do
      nil -> align_one_scanner(scanners, remaining_scanners)
      scanner -> scanner
    end
  end

  defp align_scanner(scanners, to_align) do
    possible_headings()
    |> Enum.find_value(fn heading ->
      to_align
      |> apply_heading(heading)
      |> fit_to_existing_scanner(scanners)
      |> case do
        nil ->
          nil

        scanner ->
          transform(scanner)
      end
    end)
  end

  defp fit_to_existing_scanner(scanner, existing_scanners) do
    Enum.find_value(existing_scanners, fn existing_scanner ->
      distance_frequencies =
        Enum.reduce(scanner.points, %{}, fn scanner_point, acc ->
          Enum.reduce(existing_scanner.points, acc, fn existing_point, acc ->
            Map.update(acc, subtract_mask(existing_point, scanner_point), 1, &(&1 + 1))
          end)
        end)

      case Enum.max_by(distance_frequencies, &elem(&1, 1)) do
        {distance, frequency} when frequency >= 12 ->
          %{scanner | transform: distance}

        _ ->
          nil
      end
    end)
  end

  defp apply_heading(scanner, %{
         mask: mask,
         negative?: negative?,
         facing: facing,
         rotation: rotation
       }) do
    %{
      scanner
      | points: Enum.map(scanner.points, mask),
        mask: mask,
        negative?: negative?,
        facing: facing,
        rotation: rotation
    }
  end

  defp subtract_mask({x1, y1, z1}, {x2, y2, z2}) do
    {x1 - x2, y1 - y2, z1 - z2}
  end

  defp add_mask({x1, y1, z1}, {x2, y2, z2}) do
    {x1 + x2, y1 + y2, z1 + z2}
  end

  defp rotate({x, y, z}) do
    {x, -z, y}
  end

  def possible_headings() do
    for facing <- [:x, :y, :z], negative? <- [true, false], rotation <- [0, 1, 2, 3] do
      mask =
        case facing do
          :x ->
            fn {x, y, z} -> {x, y, z} end

          :y ->
            fn {x, y, z} -> {-y, x, z} end

          :z ->
            fn {x, y, z} -> {-z, y, x} end
        end

      rotation_mask =
        case rotation do
          0 ->
            fn point -> point end

          n ->
            fn point ->
              1..n
              |> Enum.reduce(point, fn _, point ->
                rotate(point)
              end)
            end
        end

      negative_mask =
        if negative? do
          fn {x, y, z} -> {-x, -y, z} end
        else
          fn point -> point end
        end

      full_mask = fn point ->
        mask.(negative_mask.(rotation_mask.(point)))
      end

      %{mask: full_mask, negative?: negative?, facing: facing, rotation: rotation}
    end
  end
end
