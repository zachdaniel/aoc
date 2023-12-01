defmodule Aoc.Y2022.Day16 do
  use Aoc.Day

  answers do
    part_1 2119
    part_2 2615
  end

  input do
    handle_input fn input ->
      {graph, rates} =
        input
        |> String.split("\n")
        |> Enum.reduce({Graph.new(), %{}}, fn "Valve " <> rest, {graph, rates} ->
          [name, "has flow rate=" <> rest] = String.split(rest, " ", parts: 2)

          {rate, rest} =
            case Integer.parse(rest) do
              {rate, "; tunnel leads to valve " <> rest} -> {rate, rest}
              {rate, "; tunnels lead to valves " <> rest} -> {rate, rest}
            end

          Integer.parse(rest)
          valves = String.split(rest, ", ")

          graph =
            Enum.reduce(valves, Graph.add_vertex(graph, name), fn connect, graph ->
              Graph.add_edge(graph, Graph.Edge.new(name, connect))
            end)

          {graph, Map.put(rates, name, rate)}
        end)

      cost_for_each_node =
        Graph.vertices(graph)
        |> Enum.reduce(%{}, fn vertex1, acc ->
          Graph.vertices(graph)
          |> Enum.reduce(acc, fn vertex2, acc ->
            Map.put(
              acc,
              {vertex1, vertex2},
              Graph.dijkstra(graph, vertex1, vertex2) |> Enum.count() |> Kernel.-(1)
            )
          end)
        end)

      {graph, rates, cost_for_each_node}
    end
  end

  solutions do
    part_1 fn {graph, rates, costs_for_each_node} ->
      remaining = rates |> Enum.filter(fn {_, v} -> v != 0 end) |> Enum.map(&elem(&1, 0))

      graph
      |> find_maximal_route(rates, "AA", 30, costs_for_each_node, remaining)
      |> elem(0)
    end

    part_2 fn {graph, rates, costs_for_each_node} ->
      remaining = rates |> Enum.filter(fn {_, v} -> v != 0 end) |> Enum.map(&elem(&1, 0))

      optimal_solo_points =
        graph
        # Assuming we can do better than part 1
        |> find_maximal_route(rates, "AA", 30, costs_for_each_node, remaining)
        |> elem(0)

      all_routes =
        all_routes_under(graph, rates, "AA", 26, costs_for_each_node, remaining)
        |> Enum.uniq()
        |> Enum.reject(&(elem(&1, 0) == 0))

      for {your_cost, your_path} <- all_routes,
          {elephant_cost, elephant_path} <- all_routes,
          your_cost + elephant_cost > optimal_solo_points,
          disjoint?(your_path, elephant_path) do
        your_cost + elephant_cost
      end
      |> Enum.max()
    end
  end

  defp disjoint?(path1, path2) do
    MapSet.disjoint?(MapSet.new(path1), MapSet.new(path2))
  end

  defp all_routes_under(
         graph,
         rates,
         node,
         minutes_left,
         costs_for_each_node,
         remaining,
         pressure \\ 0,
         path \\ []
       )

  defp all_routes_under(_, _, _, 0, _, _, pressure, path), do: [{pressure, path}]

  defp all_routes_under(
         graph,
         rates,
         node,
         minutes_left,
         costs_for_each_node,
         remaining,
         pressure,
         path
       ) do
    Enum.flat_map(remaining, fn destination ->
      minutes_elapsed = costs_for_each_node[{node, destination}]
      minutes_left = minutes_left - (minutes_elapsed + 1)

      path =
        if minutes_left > 0 do
          [destination | path]
        else
          path
        end

      minutes_left = max(minutes_left, 0)

      pressure_gained = minutes_left * rates[destination]

      all_routes_under(
        graph,
        rates,
        destination,
        minutes_left,
        costs_for_each_node,
        remaining -- [destination],
        pressure + pressure_gained,
        path
      )
    end)
    |> Enum.concat([{pressure, path}])
  end

  defp find_maximal_route(
         graph,
         rates,
         node,
         minutes_left,
         costs_for_each_node,
         remaining,
         pressure \\ 0,
         path \\ []
       )

  defp find_maximal_route(_, _, _, 0, _, _, pressure, path), do: {pressure, path}

  defp find_maximal_route(
         graph,
         rates,
         node,
         minutes_left,
         costs_for_each_node,
         remaining,
         pressure,
         path
       ) do
    remaining
    |> Enum.map(fn destination ->
      minutes_elapsed = costs_for_each_node[{node, destination}]
      minutes_left = max(minutes_left - (minutes_elapsed + 1), 0)
      pressure_gained = minutes_left * rates[destination]

      find_maximal_route(
        graph,
        rates,
        destination,
        minutes_left,
        costs_for_each_node,
        remaining -- [destination],
        pressure + pressure_gained,
        [destination | path]
      )
    end)
    |> case do
      [] ->
        {pressure, [minutes_left | path]}

      routes ->
        Enum.max_by(routes, &elem(&1, 0))
    end
  end
end
