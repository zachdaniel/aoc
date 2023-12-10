defmodule Aoc.Y2023.Day10 do
  use Aoc.Day

  answers do
    part_1 6701
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {char, x, -y}
        end)
      end)
      |> Enum.sort_by(fn {char, _, _} ->
        # put "S" at the end so we can figure out what S connects to
        char == "S"
      end)
      |> Enum.reduce({Graph.new(), nil}, fn {char, x, y}, {graph, start} ->
        edges = edges_for_char(char, {x, y}, graph)

        start =
          if char == "S" do
            {x, y}
          else
            start
          end

        label =
          if char == "S" do
            edges = Enum.sort(edges)

            Enum.find(["|", "L", "J", "7", "F", "-"], fn char ->
              Enum.sort(edges_for_char(char, {x, y}, graph)) == edges
            end)
          else
            char
          end

        graph =
          graph
          |> Graph.add_vertex({x, y})
          |> Graph.label_vertex({x, y}, [label])

        {Enum.reduce(edges, graph, fn other_point, graph ->
           graph
           |> Graph.add_edge({x, y}, other_point)
         end), start}
      end)
    end
  end

  solutions do
    part_1 fn {graph, start} ->
      [left, right] = Graph.out_neighbors(graph, start)

      count =
        graph
        |> Graph.delete_vertex(start)
        |> Graph.dijkstra(left, right)
        |> Enum.count()

      case rem(count, 2) do
        0 -> div(count, 2)
        1 -> div(count, 2) + 1
      end
    end

    part_2 fn {graph, start} ->
      [left, right] = Graph.out_neighbors(graph, start)

      box =
        graph
        |> Graph.delete_vertex(start)
        |> Graph.dijkstra(left, right)
        |> Enum.concat([start])

      box_boundaries =
        Enum.filter(box, fn vertex ->
          Graph.vertex_labels(graph, vertex) in [["J"], ["L"], ["|"]]
        end)
        |> MapSet.new()

      graph
      |> Graph.vertices()
      |> Enum.reject(&(&1 in box))
      |> Enum.count(&inside_box?(&1, box_boundaries))
    end
  end

  defp inside_box?({x, y}, box_boundaries) do
    0..x
    |> Enum.count(&({&1, y} in box_boundaries))
    |> rem(2)
    |> Kernel.!=(0)
  end

  defp edges_for_char(char, {x, y}, graph) do
    case char do
      "." ->
        []

      "|" ->
        [{x, y + 1}, {x, y - 1}]

      "-" ->
        # points horizontal
        [{x - 1, y}, {x + 1, y}]

      "L" ->
        # points north and east
        [{x, y + 1}, {x + 1, y}]

      "J" ->
        # points north and west
        [{x, y + 1}, {x - 1, y}]

      "7" ->
        # points south and west
        [{x, y - 1}, {x - 1, y}]

      "F" ->
        # point south and east
        [{x, y - 1}, {x + 1, y}]

      "S" ->
        # all neighboring points to x, y
        [
          {x - 1, y},
          {x + 1, y},
          {x, y - 1},
          {x, y + 1}
        ]
        |> Enum.filter(fn point ->
          {x, y} in Graph.out_neighbors(graph, point)
        end)
    end
  end
end
