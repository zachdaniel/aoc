defmodule Aoc.Y2021.Day4 do
  use Aoc.Day

  answers do
    part_1 8136
  end

  input do
    handle_input fn input ->
      [numbers | rest] = String.split(input, "\n\n")

      %{
        numbers: numbers |> String.split(",") |> Enum.map(&String.to_integer/1),
        boards: parse_boards(rest)
      }
    end
  end

  solutions do
    part_1 fn input ->
      Enum.reduce_while(input.numbers, input.boards, fn number_being_called, boards ->
        boards
        |> mark_number_as_called(number_being_called)
        |> find_winning_board()
        |> case do
          {:ok, winning_board} ->
            {:halt, score_board(winning_board, number_being_called)}

          {:error, boards} ->
            {:cont, boards}
        end
      end)
    end

    part_2 fn input ->
      {_, {last_winning_board, number_that_was_called}} =
        Enum.reduce(input.numbers, {input.boards, nil}, fn number_being_called,
                                                           {boards, winning_board} ->
          boards
          |> mark_number_as_called(number_being_called)
          |> split_winning_boards()
          |> case do
            {[], remaining_boards} ->
              {remaining_boards, winning_board}

            {new_winning_boards, remaining_boards} ->
              new_winning_board = List.last(new_winning_boards)
              {remaining_boards, {new_winning_board, number_being_called}}
          end
        end)

      score_board(last_winning_board, number_that_was_called)
    end
  end

  defp parse_boards(board_strings) do
    Enum.map(board_strings, fn board_string ->
      # 22 13 17 11  0
      # 8  2 23  4 24
      # 21  9 14 16  7
      # 6 10  3 18  5
      # 1 12 20 15 19
      board_string
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {board_string, row_number}, board ->
        board_string
        |> String.split(" ", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(board, fn {value, col_number}, board ->
          Map.put(board, {row_number, col_number}, %{
            value: String.to_integer(value),
            checked?: false
          })
        end)
      end)
    end)
  end

  defp find_winning_board(boards) do
    boards
    |> Enum.find(&winning_board?/1)
    |> case do
      nil ->
        {:error, boards}

      winning_board ->
        {:ok, winning_board}
    end
  end

  defp split_winning_boards(boards) do
    Enum.split_with(boards, &winning_board?/1)
  end

  defp score_board(winning_board, number_being_called) do
    sum_of_all_unchecked_squares =
      Enum.reduce(winning_board, 0, fn {_, state}, acc ->
        if state.checked? do
          acc
        else
          acc + state.value
        end
      end)

    sum_of_all_unchecked_squares * number_being_called
  end

  defp winning_board?(board) do
    Enum.find_value(0..4, fn row_or_column ->
      if column_is_all_checked?(board, row_or_column) || row_is_all_checked?(board, row_or_column) do
        board
      end
    end)
  end

  defp column_is_all_checked?(board, column_number) do
    0..4
    |> Enum.map(fn row_number ->
      Map.get(board, {row_number, column_number})
    end)
    |> Enum.all?(& &1.checked?)
  end

  defp row_is_all_checked?(board, row_number) do
    0..4
    |> Enum.map(fn column_number ->
      Map.get(board, {row_number, column_number})
    end)
    |> Enum.all?(& &1.checked?)
  end

  defp mark_number_as_called(boards, number_being_called) do
    Enum.map(boards, fn board ->
      board
      |> Map.new(fn {coordinates, state} ->
        if state.value == number_being_called do
          {coordinates, %{state | checked?: true}}
        else
          {coordinates, state}
        end
      end)
    end)
  end
end
