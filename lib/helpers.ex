defmodule Aoc.Helpers do
  def string_to_grid(string, opts \\ []) do
    char_handler = Keyword.get(opts, :char_handler, fn char -> {:keep, char} end)
    with_size? = Keyword.get(opts, :with_size?, false)
    type = Keyword.get(opts, :type, :map)

    grid =
      string
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, acc ->
          case char_handler.(char) do
            :ignore ->
              acc

            {:keep, value} ->
              Map.put(acc, {x, -y}, value)
          end
        end)
      end)

    keys = Map.keys(grid)
    xs = Enum.map(keys, &elem(&1, 0))
    ys = Enum.map(keys, &elem(&1, 1))

    result =
      %{
        grid: grid,
        bounds: %{
          x: %{
            max: Enum.max(xs),
            min: Enum.min(xs)
          },
          y: %{
            max: Enum.max(ys),
            min: Enum.min(ys)
          }
        }
      }
      |> maybe_to_lists(type)

    if with_size? do
      result
    else
      result.grid
    end
  end

  defp maybe_to_lists(
         %{grid: grid, bounds: %{x: %{max: x_max, min: x_min}, y: %{max: y_max, min: y_min}}} =
           data,
         :rows
       ) do
    new_grid =
      y_max..y_min
      |> Enum.map(fn y ->
        x_min..x_max
        |> Enum.map(fn x ->
          Map.get(grid, {x, y})
        end)
      end)

    %{data | grid: new_grid}
  end

  defp maybe_to_lists(data, _), do: data

  def print_grid(data, opts \\ [])

  def print_grid(%{grid: grid, bounds: bounds} = data, opts) do
    print_grid_with_bounds(grid, bounds, opts)

    data
  end

  def print_grid(value, opts) when is_list(value) do
    print_grid_with_bounds(value, nil, opts)

    value
  end

  def print_grid_with_bounds(grid, bounds, opts \\ []) do
    empty_char = Keyword.get(opts, :empty_char, ".")
    value_mapper = Keyword.get(opts, :value_mapper, fn value -> value end)
    label = Keyword.get(opts, :label, "grid: ")

    if is_map(grid) do
      bounds.y.max..bounds.y.min
      |> Enum.map_join("\n", fn y ->
        bounds.x.min..bounds.x.max
        |> Enum.map_join(fn x ->
          case Map.get(grid, {x, y}) do
            nil -> empty_char
            value -> value_mapper.(value)
          end
        end)
      end)
      |> Kernel.<>("\n")
      |> label(label)
      |> IO.puts()
    else
      Enum.map_join(grid, "\n", fn line ->
        Enum.map_join(line, fn value ->
          case value do
            nil -> empty_char
            value -> value_mapper.(value)
          end
        end)
      end)
      |> Kernel.<>("\n")
      |> label(label)
      |> IO.puts()
    end

    grid
  end

  defp label(text, label) do
    "#{label}: \n#{text}"
  end

  def lcm(values) do
    Enum.reduce(values, &least_common_multiple/2)
  end

  defp least_common_multiple(0, 0), do: 0

  defp least_common_multiple(left, right) do
    div(left * right, greatest_common_denominator(left, right))
  end

  def greatest_common_denominator(left, 0), do: left
  def greatest_common_denominator(0, right), do: right

  def greatest_common_denominator(left, right),
    do: greatest_common_denominator(right, rem(left, right))
end
