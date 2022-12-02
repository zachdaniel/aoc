defmodule Aoc.Y2020.Day20 do
  use Aoc.Day

  answers do
    part_1 45_443_966_642_567
    part_2 1607
  end

  input do
    handle_input fn input ->
      input =
        input
        |> String.split("\n\n")
        |> Enum.into(%{}, fn tile ->
          [first | rest] = String.split(tile, "\n")

          id =
            first
            |> String.trim_leading("Tile ")
            |> String.trim_trailing(":")
            |> String.to_integer()

          data =
            rest
            |> Enum.with_index()
            |> Enum.reduce(MapSet.new(), fn {row, row_num}, acc ->
              row
              |> String.graphemes()
              |> Enum.with_index()
              |> Enum.reduce(acc, fn
                {"#", i}, acc ->
                  MapSet.put(acc, {i, row_num})

                _, acc ->
                  acc
              end)
            end)

          {id, data}
        end)

      dimensions =
        input
        |> Enum.count()
        |> :math.sqrt()
        |> trunc()

      sea_monster =
        """
                          #
        #    ##    ##    ###
         #  #  #  #  #  #
        """
        |> String.split("\n")
        |> Enum.with_index()
        |> Enum.reduce(MapSet.new(), fn {row, row_num}, acc ->
          row
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.reduce(acc, fn
            {"#", i}, acc ->
              MapSet.put(acc, {i, row_num})

            _, acc ->
              acc
          end)
        end)
        |> Enum.map(fn {x, y} ->
          {x, y - 1}
        end)

      %{sea_monster: sea_monster, input: input, dimensions: dimensions}
    end
  end

  solutions do
    part_1 fn input ->
      input.input
      |> find_match(input.dimensions)
      |> Enum.at(0)
      |> four_corners(input.dimensions)
      |> Enum.reduce(&Kernel.*/2)
    end

    part_2 fn input ->
      full_image =
        input.input
        |> find_match(input.dimensions)
        |> Enum.at(0)
        |> Enum.flat_map(fn {{grid_x, grid_y}, {_id, tile}} ->
          tile
          |> Enum.reject(fn {x, y} -> x == 9 or x == 0 or y == 9 or y == 0 end)
          |> Enum.map(fn {x, y} -> {x - 1 + grid_x * 8, y - 1 + grid_y * 8} end)
        end)
        |> MapSet.new()

      {grid, sea_monsters} =
        full_image
        |> orientations(8 * input.dimensions - 1)
        |> Enum.map(fn grid ->
          {grid, Enum.filter(grid, &sea_monster_at?(input.sea_monster, &1, grid))}
        end)
        |> Enum.reject(fn {_grid, matches} ->
          matches == []
        end)
        |> Enum.at(0)

      Enum.reduce(sea_monsters, grid, fn {x, y}, grid ->
        Enum.reduce(input.sea_monster, grid, fn {x_offset, y_offset}, grid ->
          MapSet.delete(grid, {x + x_offset, y + y_offset})
        end)
      end)
      |> Enum.count()
    end
  end

  defp sea_monster_at?(sea_monster, {x, y}, grid) do
    Enum.all?(sea_monster, fn {x_offset, y_offset} ->
      MapSet.member?(grid, {x + x_offset, y + y_offset})
    end)
  end

  defp four_corners(grid, dimensions) do
    dimensions = dimensions - 1

    Enum.sort([
      elem(grid[{0, 0}], 0),
      elem(grid[{0, dimensions}], 0),
      elem(grid[{dimensions, dimensions}], 0),
      elem(grid[{dimensions, 0}], 0)
    ])
  end

  defp find_match(tiles, dimensions, current_x \\ 0, current_y \\ 0, acc \\ %{})

  defp find_match(_tiles, dimensions, _current_x, dimensions, acc) do
    acc
  end

  defp find_match(tiles, dimensions, current_x, current_y, acc) do
    tiles_to_check =
      if current_x == 0 and current_y == 0 do
        tiles
      else
        Enum.flat_map(tiles, fn {id, tile} ->
          tile
          |> orientations()
          |> Enum.map(fn tile ->
            {id, tile}
          end)
        end)
      end

    tiles_to_check
    |> Enum.filter(&fits?(&1, current_x, current_y, acc))
    |> Enum.map(fn {id, possible_tile} ->
      new_tiles = Map.delete(tiles, id)

      if current_x == dimensions - 1 do
        find_match(
          new_tiles,
          dimensions,
          0,
          current_y + 1,
          Map.put(acc, {current_x, current_y}, {id, possible_tile})
        )
      else
        find_match(
          new_tiles,
          dimensions,
          current_x + 1,
          current_y,
          Map.put(acc, {current_x, current_y}, {id, possible_tile})
        )
      end
    end)
    |> Enum.filter(& &1)
    |> List.flatten()
    |> case do
      [] ->
        nil

      other ->
        other
    end
  end

  def print_tile(tile, max \\ 9) do
    0..max
    |> Enum.map_join("\n", fn x ->
      Enum.map_join(0..max, "", fn y ->
        if MapSet.member?(tile, {x, y}) do
          "#"
        else
          "."
        end
      end)
    end)
    |> Kernel.<>("\n")
    |> IO.puts()

    tile
  end

  defp fits?({_, tile}, current_x, current_y, set_tiles) do
    fits_left_neighbor?(tile, current_x, current_y, set_tiles) &&
      fits_right_neighbor?(tile, current_x, current_y, set_tiles) &&
      fits_top_neighbor?(tile, current_x, current_y, set_tiles) &&
      fits_bottom_neighbor?(tile, current_x, current_y, set_tiles)
  end

  defp fits_left_neighbor?(tile, current_x, current_y, set_tiles) do
    case Map.fetch(set_tiles, {current_x - 1, current_y}) do
      :error ->
        true

      {:ok, {_, candidate_tile}} ->
        right_side(candidate_tile) == left_side(tile)
    end
  end

  defp fits_right_neighbor?(tile, current_x, current_y, set_tiles) do
    case Map.fetch(set_tiles, {current_x + 1, current_y}) do
      :error ->
        true

      {:ok, {_, candidate_tile}} ->
        left_side(candidate_tile) == right_side(tile)
    end
  end

  defp fits_top_neighbor?(tile, current_x, current_y, set_tiles) do
    case Map.fetch(set_tiles, {current_x, current_y - 1}) do
      :error ->
        true

      {:ok, {_, candidate_tile}} ->
        bottom_side(candidate_tile) == top_side(tile)
    end
  end

  defp fits_bottom_neighbor?(tile, current_x, current_y, set_tiles) do
    case Map.fetch(set_tiles, {current_x, current_y + 1}) do
      :error ->
        true

      {:ok, {_, candidate_tile}} ->
        top_side(candidate_tile) == bottom_side(tile)
    end
  end

  def right_side(tile) do
    Enum.filter(0..9, &MapSet.member?(tile, {9, &1}))
  end

  def left_side(tile) do
    Enum.filter(0..9, &MapSet.member?(tile, {0, &1}))
  end

  def top_side(tile) do
    Enum.filter(0..9, &MapSet.member?(tile, {&1, 0}))
  end

  def bottom_side(tile) do
    Enum.filter(0..9, &MapSet.member?(tile, {&1, 9}))
  end

  defp orientations(tile, length \\ 9) do
    flipped_horizontally = flip_horizontally(tile, length)
    flipped_vertically = flip_vertically(tile, length)
    flipped_both = flip_vertically(flip_horizontally(tile, length), length)

    Enum.uniq(
      rotations(flipped_horizontally, length) ++
        rotations(flipped_vertically, length) ++ rotations(flipped_both, length)
    )
  end

  defp flip_horizontally(tile, length) do
    MapSet.new(tile, fn {x, y} ->
      {length - x, y}
    end)
  end

  defp flip_vertically(tile, length) do
    MapSet.new(tile, fn {x, y} ->
      {x, length - y}
    end)
  end

  defp rotations(tile, length) do
    first = rotate_right(tile, length)
    second = rotate_right(first, length)
    third = rotate_right(second, length)
    [tile, first, second, third]
  end

  defp rotate_right(tile, length) do
    MapSet.new(tile, fn {x, y} ->
      {y, length - x}
    end)
  end
end
