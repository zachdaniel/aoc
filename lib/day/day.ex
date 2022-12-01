defmodule Aoc.Day do
  use Spark.Dsl

  defmodule Dsl do
    @input %Spark.Dsl.Section{
      name: :input,
      schema: [
        part_1_input: [
          type: :string,
          default: "input.txt"
        ],
        part_2_input: [
          type: :string,
          default: "input.txt"
        ],
        example_input: [
          type: :string,
          default: "example_input.txt"
        ],
        part_2_example_input: [
          type: :string,
          default: "example_input.txt"
        ],
        handle_input: [
          type:
            {:spark_function_behaviour, Aoc.Day.InputHandler, {Aoc.Day.InputHandler.Function, 1}},
          required: true
        ],
        handle_part_2_input: [
          type:
            {:spark_function_behaviour, Aoc.Day.InputHandler, {Aoc.Day.InputHandler.Function, 1}},
          required: true
        ]
      ]
    }

    @solutions %Spark.Dsl.Section{
      name: :solutions,
      schema: [
        solve_part_1: [
          type: {:spark_function_behaviour, Aoc.Day.Solver, {Aoc.Day.Solver.Function, 1}},
          required: true
        ],
        solve_part_2: [
          type: {:spark_function_behaviour, Aoc.Day.Solver, {Aoc.Day.Solver.Function, 1}}
        ]
      ]
    }

    @answers %Spark.Dsl.Section{
      name: :answers,
      schema: [
        part_1: [
          type: :any
        ],
        part_2: [
          type: :any
        ]
      ]
    }

    use Spark.Dsl.Extension,
      sections: [@input, @solutions, @answers]
  end

  defmodule Info do
    alias Spark.Dsl.Extension

    def part_1_answer(day) do
      Extension.fetch_opt(day, [:answers], :part_1)
    end

    def part_2_answer(day) do
      Extension.fetch_opt(day, [:answers], :part_1)
    end

    def part_1_input(day) do
      Extension.get_opt(day, [:input], :part_1_input, "input.txt")
      |> relative_to(day)
    end

    def part_2_input(day) do
      Extension.get_opt(day, [:input], :part_2_input, "input.txt")
      |> relative_to(day)
    end

    def example_input(day) do
      Extension.get_opt(day, [:input], :example_input, "example_input.txt")
      |> relative_to(day)
    end

    def part_2_example_input(day) do
      Extension.get_opt(day, [:input], :part_2_example_input, "example_input.txt")
      |> relative_to(day)
    end

    def input_handler(day) do
      Extension.get_opt(day, [:input], :handle_input)
    end

    def part_1_input_handler(day) do
      Extension.get_opt(day, [:input], :handle_part_2_input) || input_handler(day)
    end

    def part_1_solution(day) do
      Extension.get_opt(day, [:solutions], :part_1)
    end

    def part_2_solution(day) do
      Extension.get_opt(day, [:solutions], :part_2) || part_1_solution(day)
    end

    defp relative_to(path, day) do
      Path.join(day.module_info()[:compile][:source] |> Path.dirname(), path)
    end
  end

  use Spark.Dsl,
    default_extensions: [
      extensions: [Dsl]
    ]
end
