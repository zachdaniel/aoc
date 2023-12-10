defmodule AocTest do
  use ExUnit.Case
  doctest Aoc

  days =
    "lib/Y*"
    |> Path.wildcard()
    |> Enum.map(&String.trim_leading(&1, "lib/Y"))
    |> Enum.flat_map(fn year ->
      "lib/Y#{year}/day_*"
      |> Path.wildcard()
      |> Enum.map(&String.trim_leading(&1, "lib/Y#{year}/day_"))
      |> Enum.map(fn day ->
        module = Module.concat(["Aoc", "Y#{year}", "Day#{day}"])
        Code.ensure_compiled!(module)
      end)
    end)

  for day <- days do
    path = day.__info__(:compile)[:source] |> :binary.list_to_bin() |> Path.relative_to_cwd()

    unless {:ok, true} == Aoc.Day.Info.part_1_answer_visual?(day) do
      @tag String.to_atom(inspect(day))
      case Aoc.Day.Info.part_1_answer(day) do
        {:ok, part_1_answer} when not is_nil(part_1_answer) ->
          test "#{inspect(day)}.solutions.part_1 matches answers.part_1 #{path}" do
            assert Aoc.Day.compute_answer(unquote(day), :part_1, false) == unquote(part_1_answer)
          end

        _ ->
          :ok
      end
    end

    unless {:ok, true} == Aoc.Day.Info.part_2_answer_visual?(day) do
      @tag String.to_atom(inspect(day))
      case Aoc.Day.Info.part_2_answer(day) do
        {:ok, part_2_answer} when not is_nil(part_2_answer) ->
          test "#{inspect(day)}.solutions.part_2 matches #{inspect(day)}.answers.part_2 #{path}" do
            assert Aoc.Day.compute_answer(unquote(day), :part_2, false) == unquote(part_2_answer)
          end

        _ ->
          :ok
      end
    end
  end

  test "greets the world" do
  end
end
