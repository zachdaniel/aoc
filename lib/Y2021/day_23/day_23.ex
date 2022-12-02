defmodule Aoc.Y2021.Day23 do
  use Aoc.Day

  defmodule Amphipod do
    defstruct [:type, at_destination?: false]
  end

  defmodule Room do
    defstruct amphipods: []
  end

  defmodule Cave do
    defstruct hallway: Map.new(0..10, &{&1, nil}), rooms: [], cost: 0
  end

  answers do
    part_1 16489
    part_2 43413
  end

  input do
    handle_input fn input ->
      [hallway | rooms] =
        input
        |> String.split("\n", trim: true)
        |> Enum.drop(1)

      hallway =
        hallway
        |> String.trim_leading("#")
        |> String.trim_trailing("#")
        |> String.graphemes()
        |> Enum.with_index()
        |> Map.new(fn {character, index} ->
          amphipod =
            if character == "." do
              nil
            else
              %Amphipod{type: character}
            end

          {index, amphipod}
        end)

      rooms =
        rooms
        |> :lists.droplast()
        |> Enum.map(fn line ->
          line
          |> String.trim()
          |> String.split("#", trim: true)
        end)
        |> Enum.zip()
        |> Enum.map(fn amphipods ->
          amphipods =
            amphipods
            |> Tuple.to_list()
            |> Enum.map(fn amphipod ->
              if amphipod == "." do
                nil
              else
                %Amphipod{type: amphipod}
              end
            end)

          %Room{
            amphipods: amphipods
          }
        end)

      set_at_destination(%Cave{rooms: rooms, hallway: hallway})
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> find_minimal_cost_solution()
      |> elem(1)
      |> Map.get(:cost)
    end

    part_2 fn input ->
      input
      |> find_minimal_cost_solution()
      |> elem(1)
      |> Map.get(:cost)
    end
  end

  defp set_at_destination(%Cave{rooms: rooms} = cave) do
    rooms =
      rooms
      |> Enum.with_index()
      |> Enum.map(fn {room, index} ->
        amphipod_at_home =
          case index do
            0 -> "A"
            1 -> "B"
            2 -> "C"
            3 -> "D"
          end

        %{room | amphipods: set_at_destination(room.amphipods, amphipod_at_home)}
      end)

    %{cave | rooms: rooms}
  end

  defp set_at_destination(amphipods, amphipod_at_home) do
    {at_home, not_at_home} =
      amphipods
      |> Enum.reverse()
      |> Enum.split_while(fn amphipod ->
        amphipod && amphipod.type == amphipod_at_home
      end)

    Enum.reverse(Enum.map(at_home, &Map.put(&1, :at_destination?, true)) ++ not_at_home)
  end

  defp find_minimal_cost_solution(cave, cache \\ %{}, lowest \\ nil) do
    if solved?(cave) do
      if is_nil(lowest) || cave.cost < lowest do
        {cache, cave}
      else
        {cache, nil}
      end
    else
      cond do
        {cave.rooms, cave.hallway} in cache ->
          found_solution = Map.get(cache, {cave.rooms, cave.hallway})

          if is_nil(lowest) || found_solution < lowest do
            {cache, %{cave | cost: lowest}}
          else
            {cache, nil}
          end

        true ->
          if not is_nil(lowest) && cave.cost >= lowest do
            {cache, nil}
          else
            {cache, states} =
              cave
              |> possible_next_states()
              |> Enum.reject(fn state ->
                case Map.fetch(cache, {state.rooms, state.hallway}) do
                  {:ok, count} when count <= state.cost ->
                    true

                  _ ->
                    false
                end
              end)
              |> Enum.reduce({cache, []}, fn state, {cache, states} ->
                {Map.put(cache, {state.rooms, state.hallway}, state.cost), [state | states]}
              end)

            {cache, solution, _} =
              Enum.reduce(states, {cache, nil, lowest}, fn state,
                                                           {cache, last_solution, lowest} ->
                {cache, solution} = find_minimal_cost_solution(state, cache, lowest)

                if solution && solution.cost <= lowest do
                  {cache, solution, solution.cost}
                else
                  {cache, last_solution, lowest}
                end
              end)

            {cache, solution}
          end
      end
    end
  end

  defp possible_next_states(%Cave{} = cave) do
    rooms = sort_rooms(cave)

    case move_from_room_to_room(cave) ++ move_from_hallway_to_room(cave) do
      [] ->
        Enum.map(rooms, fn room ->
          [
            move_out_of_room(cave, room),
            move_out_of_room(cave, room),
            move_out_of_room(cave, room),
            move_out_of_room(cave, room)
          ]
        end)
        |> List.flatten()

      other ->
        other
    end
  end

  defp sort_rooms(cave) do
    0..3
    |> Enum.sort_by(fn room_index ->
      room = Enum.at(cave.rooms, room_index)

      room.amphipods
      |> Enum.with_index()
      |> Enum.map(fn {amphipod, index} ->
        move_cost(amphipod, index + 1)
      end)
      |> Enum.sum()
    end)
  end

  def move_from_hallway_to_room(%Cave{} = cave) do
    cave.hallway
    |> Enum.reject(fn {_key, amphipod} -> is_nil(amphipod) end)
    |> Enum.flat_map(fn {hallway_space, amphipod} ->
      if can_go_home?(cave, hallway_space, amphipod) do
        [move_amphipod_home(cave, hallway_space, amphipod)]
      else
        []
      end
    end)
  end

  # technically just an optimization
  defp move_from_room_to_room(%Cave{} = cave) do
    cave.rooms
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {%Room{} = room, room_index} ->
        entrypoint = (room_index + 1) * 2

        room.amphipods
        |> Enum.split_while(&is_nil/1)
        |> case do
          {_nils, []} ->
            []

          {nils, [amphipod | rest]} ->
            cave = %{
              cave
              | hallway: Map.put(cave.hallway, entrypoint, amphipod),
                rooms:
                  List.replace_at(cave.rooms, room_index, %{
                    room
                    | amphipods: nils ++ [nil | rest]
                  }),
                cost: cave.cost + move_cost(amphipod, Enum.count(nils) + 1)
            }

            if can_go_home?(cave, entrypoint, amphipod) do
              [move_amphipod_home(cave, entrypoint, amphipod)]
            else
              []
            end
        end
    end)
  end

  defp move_amphipod_home(cave, hallway_space, amphipod) do
    room_index = amphipod_home(amphipod)
    room = Enum.at(cave.rooms, room_index)

    {[_ | rest_nils], rest} = Enum.split_while(room.amphipods, &is_nil/1)

    %{
      cave
      | rooms:
          List.replace_at(cave.rooms, room_index, %{
            room
            | amphipods: rest_nils ++ [%{amphipod | at_destination?: true} | rest]
          }),
        hallway: Map.put(cave.hallway, hallway_space, nil),
        cost:
          cave.cost +
            move_cost(
              amphipod,
              moves_from_room_to_hallway(room_index, hallway_space) + Enum.count(rest_nils)
            )
    }
  end

  defp move_out_of_room(%Cave{} = cave, index) do
    room = Enum.at(cave.rooms, index)

    case Enum.split_while(room.amphipods, &is_nil/1) do
      {_, []} ->
        []

      {_, [%Amphipod{at_destination?: true} | _]} ->
        []

      _ ->
        cave
        |> available_hallway_spaces(index)
        |> Enum.map(fn hallway_space ->
          move_from_room_to_hallway(cave, index, hallway_space)
        end)
    end
  end

  defp move_from_room_to_hallway(%Cave{} = cave, room_index, hallway_space) do
    room = Enum.at(cave.rooms, room_index)

    {nils, [amphipod | rest]} = Enum.split_while(room.amphipods, &is_nil/1)

    %{
      cave
      | rooms: List.replace_at(cave.rooms, room_index, %{room | amphipods: nils ++ [nil | rest]}),
        hallway: Map.put(cave.hallway, hallway_space, amphipod),
        cost:
          cave.cost +
            move_cost(
              amphipod,
              moves_from_room_to_hallway(room_index, hallway_space) + Enum.count(nils)
            )
    }
  end

  def move_cost(nil, _), do: 0
  def move_cost(%Amphipod{type: "A"}, moves), do: moves
  def move_cost(%Amphipod{type: "B"}, moves), do: moves * 10
  def move_cost(%Amphipod{type: "C"}, moves), do: moves * 100
  def move_cost(%Amphipod{type: "D"}, moves), do: moves * 1000

  def moves_from_room_to_hallway(room_index, hallway) do
    entrypoint = (room_index + 1) * 2

    abs(hallway - entrypoint) + 1
  end

  defp can_go_home?(%Cave{} = cave, hallway_space, %Amphipod{} = amphipod) do
    if home_available?(cave, amphipod) do
      entry = (amphipod_home(amphipod) + 1) * 2

      if hallway_space > entry do
        (hallway_space - 1)..entry
        |> Enum.all?(&is_nil(cave.hallway[&1]))
      else
        (hallway_space + 1)..entry
        |> Enum.all?(&is_nil(cave.hallway[&1]))
      end
    else
      false
    end
  end

  defp home_available?(cave, amphipod) do
    cave.rooms
    |> Enum.at(amphipod_home(amphipod))
    |> Map.get(:amphipods)
    |> Enum.drop_while(&is_nil/1)
    |> case do
      [] ->
        true

      [%Amphipod{at_destination?: true} | _] ->
        true

      _ ->
        false
    end
  end

  defp amphipod_home(%Amphipod{type: "A"}), do: 0
  defp amphipod_home(%Amphipod{type: "B"}), do: 1
  defp amphipod_home(%Amphipod{type: "C"}), do: 2
  defp amphipod_home(%Amphipod{type: "D"}), do: 3

  defp available_hallway_spaces(%Cave{} = cave, room) do
    entry = (room + 1) * 2
    left_hallway_limit = entry - 1
    right_hallway_limit = entry + 1

    left_side =
      0..left_hallway_limit
      |> Enum.filter(fn hallway_space ->
        hallway_space..left_hallway_limit
        |> Enum.all?(fn hallway_space ->
          is_nil(cave.hallway[hallway_space])
        end)
      end)

    right_side =
      10..right_hallway_limit
      |> Enum.filter(fn hallway_space ->
        hallway_space..right_hallway_limit
        |> Enum.all?(fn hallway_space ->
          is_nil(cave.hallway[hallway_space])
        end)
      end)
      |> Enum.reverse()

    Enum.reject(left_side ++ right_side, &(&1 in [2, 4, 6, 8]))
  end

  def solved?(%Cave{rooms: rooms}) do
    rooms
    |> Enum.flat_map(& &1.amphipods)
    |> Enum.all?(fn amphipod ->
      amphipod && amphipod.at_destination?
    end)
  end

  def solved?(_), do: false
end
