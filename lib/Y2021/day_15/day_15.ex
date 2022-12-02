defmodule Aoc.Y2021.Day15 do
  use Aoc.Day

  answers do
    part_1 415
    part_2 2864
  end

  input do
    handle_input fn input ->
      risk_levels =
        input
        |> String.split("\n", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {line, y}, acc ->
          line
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {risk_level, x}, acc ->
            Map.put(acc, {x, y}, String.to_integer(risk_level))
          end)
        end)
        |> Map.put({0, 0}, 0)

      coordinates = Map.keys(risk_levels)

      endpoint_x = coordinates |> Enum.map(&elem(&1, 0)) |> Enum.max()
      endpoint_y = coordinates |> Enum.map(&elem(&1, 1)) |> Enum.max()

      %{risk_levels: risk_levels, endpoint: {endpoint_x, endpoint_y}}
    end

    handle_part_2_input fn input ->
      lines = String.split(input, "\n", trim: true)
      endpoint_y = Enum.count(lines)
      endpoint_x = String.length(Enum.at(lines, 0))

      risk_levels =
        lines
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {line, y}, acc ->
          line
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {risk_level, x}, acc ->
            add_risk_level(acc, x, y, endpoint_x, endpoint_y, String.to_integer(risk_level))
          end)
        end)
        |> Map.put({0, 0}, 0)

      coordinates = Map.keys(risk_levels)

      endpoint_x = coordinates |> Enum.map(&elem(&1, 0)) |> Enum.max()
      endpoint_y = coordinates |> Enum.map(&elem(&1, 1)) |> Enum.max()

      %{risk_levels: risk_levels, endpoint: {endpoint_x, endpoint_y}}
    end
  end

  solutions do
    part_1 &shortest_path_total_risk/1
  end

  defp add_risk_level(new_risk_levels, x, y, endpoint_x, endpoint_y, risk_level) do
    for x_mod <- 0..4, y_mod <- 0..4, reduce: new_risk_levels do
      new_risk_levels ->
        coordinates = {
          x + endpoint_x * x_mod,
          y + endpoint_y * y_mod
        }

        new_risk_level = risk_level + x_mod + y_mod

        new_risk_level =
          if new_risk_level > 9 do
            new_risk_level - 9
          else
            new_risk_level
          end

        Map.put(new_risk_levels, coordinates, new_risk_level)
    end
  end

  defp shortest_path_total_risk(%{risk_levels: risk_levels} = input) do
    unvisited_set = MapSet.new(risk_levels, &elem(&1, 0))

    tentative_distances = %{{0, 0} => 0}

    do_shortest_path_total_risk(
      input,
      {0, 0},
      unvisited_set,
      tentative_distances,
      tentative_distances,
      Enum.count(unvisited_set)
    )
  end

  defp do_shortest_path_total_risk(
         %{risk_levels: risk_levels, endpoint: endpoint} = input,
         current_point,
         unvisited_set,
         tentative_distances,
         unvisited_tentative_distances,
         set_count
       ) do
    current_distance = tentative_distances[current_point]

    {tentative_distances, unvisited_tentative_distances} =
      current_point
      |> neighbors()
      |> Enum.filter(&MapSet.member?(unvisited_set, &1))
      |> Enum.reduce({tentative_distances, unvisited_tentative_distances}, fn neighboring_point,
                                                                              {tentative_distances,
                                                                               unvisited_tentative_distances} ->
        potential_new_distance = risk_levels[neighboring_point] + current_distance

        if !Map.has_key?(tentative_distances, neighboring_point) ||
             (tentative_distances[neighboring_point] || :infinity) > potential_new_distance do
          {Map.put(tentative_distances, neighboring_point, potential_new_distance),
           Map.put(unvisited_tentative_distances, neighboring_point, potential_new_distance)}
        else
          {tentative_distances, unvisited_tentative_distances}
        end
      end)

    unvisited_set = MapSet.delete(unvisited_set, current_point)
    unvisited_tentative_distances = Map.delete(unvisited_tentative_distances, current_point)

    if current_point == endpoint do
      tentative_distances[endpoint]
    else
      {next_point, _} =
        unvisited_tentative_distances
        |> Enum.reduce({nil, :infinity}, fn {point, value}, {smallest_point, smallest_value} ->
          if value < smallest_value && MapSet.member?(unvisited_set, point) do
            {point, value}
          else
            {smallest_point, smallest_value}
          end
        end)

      do_shortest_path_total_risk(
        input,
        next_point,
        unvisited_set,
        tentative_distances,
        unvisited_tentative_distances,
        set_count - 1
      )
    end
  end

  defp neighbors({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end
end
