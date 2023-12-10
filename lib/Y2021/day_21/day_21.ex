defmodule Aoc.Y2021.Day21 do
  use Aoc.Day

  defmodule Player do
    defstruct [:position, :name, score: 0]
  end

  defmodule GameState do
    defstruct [:players, :die, in_universes: 1]
  end

  defmodule Universes do
    defstruct wins: %{}
  end

  defmodule DeterministicDie do
    defstruct current_value: 0, number_of_rolls: 0

    def roll(%__MODULE__{} = die) do
      new_value =
        case die.current_value do
          100 ->
            1

          value ->
            value + 1
        end

      %{die | current_value: new_value, number_of_rolls: die.number_of_rolls + 1}
    end
  end

  answers do
    part_1 506_466
    part_2 632_979_211_251_440
  end

  input do
    handle_input fn input ->
      [player_1, player_2] = String.split(input, "\n")

      [_, player_1_position] = String.split(player_1, ": ")
      [_, player_2_position] = String.split(player_2, ": ")

      %GameState{
        players: [
          %Player{position: String.to_integer(player_1_position), name: "Player 1"},
          %Player{position: String.to_integer(player_2_position), name: "Player 2"}
        ],
        die: %DeterministicDie{}
      }
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> play_until_score_reached(1000)
      |> get_part1_answer()
    end

    part_2 fn input ->
      input
      |> play_until_score_reached_with_dirac_die(21)
      |> get_part2_answer()
    end
  end

  defp get_part2_answer(wins) do
    wins |> Map.values() |> Enum.max()
  end

  defp play_until_score_reached_with_dirac_die(game_state, score, wins \\ %{}) do
    new_game_states = play_dirac_round(game_state, score)

    {new_wins, new_game_states} =
      Enum.reduce(new_game_states, {wins, []}, fn game_state, {wins, game_states} ->
        case Enum.find(game_state.players, &(&1.score >= score)) do
          nil ->
            {wins, [game_state | game_states]}

          winner ->
            {Map.update(
               wins,
               winner.name,
               game_state.in_universes,
               &(&1 + game_state.in_universes)
             ), game_states}
        end
      end)

    Enum.reduce(new_game_states, new_wins, fn new_game_state, wins ->
      play_until_score_reached_with_dirac_die(new_game_state, score, wins)
    end)
  end

  def sum_of_all_integers_below(n) do
    div(n * (n - 1), 2)
  end

  defp play_until_score_reached(game_state, score) do
    new_game_state = play_round(game_state, score)

    if Enum.any?(new_game_state.players, &(&1.score >= score)) do
      new_game_state
    else
      play_until_score_reached(new_game_state, score)
    end
  end

  @possible_rolls %{3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1}

  defp play_dirac_round(game_state, score, player_2? \\ false) do
    @possible_rolls
    |> Enum.reduce([], fn {roll, times}, game_states ->
      player =
        if player_2? do
          Enum.at(game_state.players, 1)
        else
          Enum.at(game_state.players, 0)
        end

      new_player = move_player(player, roll)

      new_game_state = %{game_state | in_universes: game_state.in_universes * times}

      [replace_player(new_game_state, new_player) | game_states]
    end)
    |> maybe_play_player2(score, player_2?)
  end

  defp maybe_play_player2(game_states, _score, true), do: game_states

  defp maybe_play_player2(game_states, score, false) do
    Enum.flat_map(game_states, fn game_state ->
      if Enum.find(game_state.players, &(&1.score >= score)) do
        [game_state]
      else
        play_dirac_round(game_state, score, true)
      end
    end)
  end

  # defp play_dirac_round(game_state, score) do
  #   game_state_without_players = %{game_state | players: []}

  #   {game_state, _} =
  #     Enum.reduce(game_state.players, {[], false}, fn player, {game_states, won?} ->
  #       if won? do
  #         {%{game_state | players: game_state.players}, true}
  #       else
  #         Enum.reduce(1..3, game_states, fn roll, game_states ->
  #           nil
  #         end)

  #         {new_game_state, moves} =
  #           case moves do
  #             nil ->
  #               roll_dice(game_state, 3)

  #             moves ->
  #               {game_state, moves}
  #           end

  #         new_player = move_player(player, moves)

  #         {replace_player(new_game_state, player), new_player.score >= score}
  #       end
  #     end)

  #   game_state
  # end

  defp play_round(game_state, score) do
    {game_state, _} =
      Enum.reduce(game_state.players, {game_state, false}, fn player, {game_state, won?} ->
        if won? do
          {%{game_state | players: game_state.players}, true}
        else
          {new_game_state, moves} = roll_dice(game_state, 3)

          new_player = move_player(player, moves)

          {replace_player(new_game_state, new_player), new_player.score >= score}
        end
      end)

    game_state
  end

  def replace_player(game_state, %{name: "Player 1"} = new_player) do
    %{
      game_state
      | players: [new_player, Enum.at(game_state.players, 1)]
    }
  end

  def replace_player(game_state, %{name: "Player 2"} = new_player) do
    %{
      game_state
      | players: [Enum.at(game_state.players, 0), new_player]
    }
  end

  defp move_player(%Player{} = player, moves) do
    new_position =
      case rem(player.position + moves, 10) do
        0 -> 10
        position -> position
      end

    %{player | position: new_position, score: player.score + new_position}
  end

  defp roll_dice(game_state, number_of_times, total \\ 0)
  defp roll_dice(game_state, 0, total), do: {game_state, total}

  defp roll_dice(%GameState{} = game_state, number_of_times, total) do
    new_die = DeterministicDie.roll(game_state.die)
    roll_dice(%{game_state | die: new_die}, number_of_times - 1, total + new_die.current_value)
  end

  defp get_part1_answer(%GameState{
         players: players,
         die: %DeterministicDie{number_of_rolls: number_of_rolls}
       }) do
    players
    |> Enum.map(& &1.score)
    |> Enum.min()
    |> Kernel.*(number_of_rolls)
  end
end
