defmodule Aoc.Y2022.Day12 do
  use Aoc.Day

  @letters ?a..?z |> Enum.to_list() |> to_string() |> String.graphemes()

  answers do
    part_1 490
    part_2 488
  end

  input do
    handle_input fn input ->
      [first | _] = lines =
        input
        |> String.split("\n", trim: true)

      max_y = Enum.count(lines) - 0
      max_x = String.length(first) - 0

      {coords, s, e} =
        lines
        |> Enum.with_index()
        |> Enum.reduce({%{}, nil, nil}, fn {value, row}, {acc, s, e} ->
          value
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.reduce({acc, s, e}, fn {letter, col}, {acc, s, e} ->
            {letter, s} =
            if letter == "S" do
              {"a", {row, col}}
            else
              {letter, s}
            end
            {letter, e} =
              if letter == "E" do
                {"z", {row, col}}
              else
                {letter, e}
              end

            {Map.put(acc, {row, col}, Enum.find_index(@letters, &(&1 == letter))), s, e}
          end)
        end)

      graph =
        Graph.new()
        |> Graph.add_edges(Map.keys(coords))

      graph = Enum.reduce(coords, graph, fn {coord, value}, graph ->
        coord
        |> neighbors()
        |> Enum.reduce(graph, fn neighbor, graph ->
          case Map.fetch(coords, neighbor) do
            :error ->
              graph
            {:ok, v} ->
              if v <= value + 1 do
                 Graph.add_edge(graph, Graph.Edge.new(coord, neighbor))
              else
                graph
              end
          end
        end)
      end)

      %{coords: coords, max_x: max_x, max_y: max_y, s: s, e: e, graph: graph}
    end
  end

  solutions do
    part_1 fn input ->
      Graph.Pathfinding.dijkstra(input.graph, input.s, input.e) |> Enum.count() |> Kernel.-(1)
    end

    part_2 fn input ->
      input.coords
      |> Enum.filter(fn {_key, value} ->
        value == 0
      end)
      |> Enum.flat_map(fn {key, _} ->
        case Graph.Pathfinding.dijkstra(input.graph, key, input.e) do
          nil ->
            []
          path ->
            [path |> Enum.count() |> Kernel.-(1)]
        end
      end)
      |> Enum.min()
    end
  end

  defp neighbors({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end
end
