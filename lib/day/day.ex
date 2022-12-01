defmodule Aoc.Day do
  alias Aoc.Day.Info
  use Spark.Dsl, default_extensions: [extensions: [Aoc.Day.Dsl]]

  def compute_missing_answer(day) do
    part =
      case Info.part_1_answer(day) do
        {:ok, _} ->
          :part_2

        _ ->
          :part_1
      end

    example? = Info.use_example?(day)

    input =
      case part do
        :part_1 ->
          if example? do
            Info.example_input(day)
          else
            Info.part_1_input(day)
          end

        :part_2 ->
          if example? do
            Info.part_2_example_input(day)
          else
            Info.part_2_input(day)
          end
      end

    input = File.read!(input)

    handled_input =
      case part do
        :part_1 ->
          handle(Info.input_handler(day), input)

        :part_2 ->
          handle(Info.part_2_input_handler(day), input)
      end

    solution =
      case part do
        :part_1 ->
          solve(Info.part_1_solution(day), handled_input)

        :part_2 ->
          solve(Info.part_2_solution(day), handled_input)
      end

    part =
      if example? do
        "#{part}_example"
      else
        part
      end

    {part, solution}
  end

  defp solve(nil, _), do: nil

  defp solve({mod, opts}, input) do
    mod.solve(input, opts)
  end

  defp handle(nil, input), do: input

  defp handle({mod, opts}, input) do
    mod.handle(input, opts)
  end
end
