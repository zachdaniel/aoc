defmodule Aoc.Y2023.Day17 do
  use Aoc.Day
  use Nebulex.Caching

  answers do
    part_1 722
    part_2 894
  end

  input do
    use_example? false

    handle_input fn input ->
      input
      |> string_to_grid(with_size?: true, char_handler: &String.to_integer/1)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> to_graph(1, 3)
      |> shortest_path_length(input)
    end

    part_2 fn input ->
      input
      |> to_graph(4, 10)
      |> shortest_path_length(input)
    end
  end

  defp to_graph(input, min_travel, max_travel) do
    Enum.reduce(input.grid, Graph.new(), fn {{x, y}, _value}, graph ->
      add_reachable_points(graph, {x, y}, input.grid, input.bounds, min_travel, max_travel)
    end)
  end

  defp shortest_path_length(graph, input) do
    graph
    |> Graph.dijkstra({0, 0}, {input.bounds.x.max, input.bounds.y.min})
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [left, right] ->
      Graph.edge(graph, left, right).weight
    end)
    |> Enum.sum()
  end

  defp points_for(grid, {from_x, from_y}, {to_x, to_y}) do
    from_y..to_y
    |> Enum.flat_map(fn y ->
      Enum.map(from_x..to_x, &{&1, y})
    end)
    |> Enum.map(fn {x, y} ->
      if {x, y} == {from_x, from_y} do
        0
      else
        grid[{x, y}]
      end
    end)
    |> Enum.sum()
  end

  defp add_reachable_points(graph, {x, y}, grid, bounds, min_travel, max_travel) do
    min_travel..max_travel
    |> Enum.flat_map(fn distance ->
      [
        {{x, y - distance}, :vertical, :horizontalw},
        {{x, y + distance}, :vertical, :horizontalw},
        {{x + distance, y}, :horizontalw, :vertical},
        {{x - distance, y}, :horizontalw, :vertical}

        # Why in the *actual fuck* does this not work but the above *does*????????
        # {{x, y - distance}, :vertical, :horizontal},
        # {{x, y + distance}, :vertical, :horizontal},
        # {{x + distance, y}, :horizontal, :vertical},
        # {{x - distance, y}, :horizontal, :vertical}
      ]
    end)
    |> Enum.filter(fn {{dest_x, dest_y}, _going, _came_from} ->
      Map.has_key?(grid, {dest_x, dest_y})
    end)
    |> Enum.reduce(graph, fn {{dest_x, dest_y}, going, came_from}, graph ->
      dest_edge =
        {dest_x, dest_y, going}

      source_edge =
        {x, y, came_from}

      graph =
        if {dest_x, dest_y} == {bounds.x.max, bounds.y.min} do
          Graph.add_edge(graph, dest_edge, {bounds.x.max, bounds.y.min}, weight: 0)
        else
          graph
        end

      graph =
        if {x, y} == {0, 0} do
          Graph.add_edge(graph, {0, 0}, source_edge, weight: 0)
        else
          graph
        end

      Graph.add_edge(graph, source_edge, dest_edge,
        weight: points_for(grid, {x, y}, {dest_x, dest_y})
      )
    end)
  end
end
