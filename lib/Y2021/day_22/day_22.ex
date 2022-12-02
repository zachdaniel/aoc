defmodule Aoc.Y2021.Day22 do
  use Aoc.Day

  defmodule Cuboid do
    defstruct [:x, :y, :z]

    def volume(%Cuboid{x: x, y: y, z: z}) do
      range_size(x) * range_size(y) * range_size(z)
    end

    defp range_size(first..last) do
      max(0, max(first, last) - min(first, last))
    end
  end

  defmodule Instruction do
    defstruct [:cuboid, :toggle]
  end

  defmodule Reactor do
    defstruct cuboids: []

    def initialize(instructions) do
      Enum.reduce(instructions, %__MODULE__{}, &follow_instruction(&2, &1))
    end

    def follow_instruction(%__MODULE__{} = reactor, %Instruction{cuboid: cuboid, toggle: toggle}) do
      case get_overlaps(reactor, cuboid) do
        {overlaps, non_overlaps} ->
          new_reactor = split_overlaps(%{reactor | cuboids: non_overlaps}, cuboid, overlaps)

          if toggle == :on do
            %{new_reactor | cuboids: [cuboid | new_reactor.cuboids]}
          else
            new_reactor
          end
      end
    end

    defp split_overlaps(reactor, _cuboid, []), do: reactor

    defp split_overlaps(reactor, cuboid, [overlapping | rest]) do
      overlap = get_overlapping_cuboid(cuboid, overlapping)

      if overlap == overlapping do
        split_overlaps(
          reactor,
          cuboid,
          rest
        )
      else
        {first, second} =
          cond do
            overlapping.x.first < overlap.x.first ->
              split_cuboid(overlapping, :x, overlap.x.first)

            overlap.x.last < overlapping.x.last ->
              split_cuboid(overlapping, :x, overlap.x.last) |> flip()

            overlapping.y.first < overlap.y.first ->
              split_cuboid(overlapping, :y, overlap.y.first)

            overlap.y.last < overlapping.y.last ->
              split_cuboid(overlapping, :y, overlap.y.last) |> flip()

            overlapping.z.first < overlap.z.first ->
              split_cuboid(overlapping, :z, overlap.z.first)

            overlap.z.last < overlapping.z.last ->
              split_cuboid(overlapping, :z, overlap.z.last) |> flip()

            true ->
              raise "unreachable"
          end

        cuboids =
          if real?(first) do
            [first | reactor.cuboids]
          else
            reactor.cuboids
          end

        overlaps =
          if real?(second) do
            [second | rest]
          else
            rest
          end

        split_overlaps(%{reactor | cuboids: cuboids}, cuboid, overlaps)
      end
    end

    defp real?(%Cuboid{x: x, y: y, z: z}) do
      real_range?(x) && real_range?(y) && real_range?(z)
    end

    defp real_range?(first..last) do
      first <= last
    end

    defp flip({left, right}), do: {right, left}

    defp split_cuboid(source, axis, value) do
      {
        source
        |> Map.update!(axis, fn range ->
          range.first..value
        end),
        source
        |> Map.update!(axis, fn range ->
          value..range.last
        end)
      }
    end

    defp get_overlapping_cuboid(%Cuboid{x: x1, y: y1, z: z1}, %Cuboid{x: x2, y: y2, z: z2}) do
      %Cuboid{
        x: get_overlapping_range(x1, x2),
        y: get_overlapping_range(y1, y2),
        z: get_overlapping_range(z1, z2)
      }
    end

    defp get_overlaps(%Reactor{cuboids: cuboids}, cuboid) do
      Enum.split_with(cuboids, &(overlaps?(&1, cuboid) || overlaps?(cuboid, &1)))
    end

    def overlaps?(%Cuboid{x: x1, y: y1, z: z1}, %Cuboid{x: x2, y: y2, z: z2}) do
      range_overlaps?(x1, x2) &&
        range_overlaps?(y1, y2) &&
        range_overlaps?(z1, z2)
    end

    defp range_overlaps?(left, right) do
      right.first < left.last && left.first < right.last
    end

    defp get_overlapping_range(left, right) do
      max(left.first, right.first)..min(left.last, right.last)
    end
  end

  answers do
    part_1 603_661
    part_2 1_237_264_238_382_479
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [on_or_off, coordinates] = String.split(line, " ")
        [x, y, z] = String.split(coordinates, ",")
        x = String.trim_leading(x, "x=")
        y = String.trim_leading(y, "y=")
        z = String.trim_leading(z, "z=")

        toggle =
          case on_or_off do
            "on" -> :on
            "off" -> :off
          end

        %Instruction{
          toggle: toggle,
          cuboid: %Cuboid{x: parse_range(x), y: parse_range(y), z: parse_range(z)}
        }
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> Enum.reject(fn %Instruction{cuboid: %Cuboid{x: x, y: y, z: z}} ->
        out_of_part_1_bounds?(x) ||
          out_of_part_1_bounds?(y) ||
          out_of_part_1_bounds?(z)
      end)
      |> Reactor.initialize()
      |> Map.get(:cuboids)
      |> Enum.map(&Cuboid.volume/1)
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> Reactor.initialize()
      |> Map.get(:cuboids)
      |> Enum.map(&Cuboid.volume/1)
      |> Enum.sum()
    end
  end

  defp parse_range(range) do
    [left, right] = String.split(range, "..")
    String.to_integer(left)..(String.to_integer(right) + 1)
  end

  defp out_of_part_1_bounds?(range) do
    range.first < -50 || range.last > 50
  end
end
