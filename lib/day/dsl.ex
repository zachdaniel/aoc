defmodule Aoc.Day.Dsl do
  @input %Spark.Dsl.Section{
    name: :input,
    schema: [
      use_example?: [
        type: :boolean,
        default: false
      ],
      part_1_input: [
        type: :string,
        default: "input.txt"
      ],
      part_2_input: [
        type: :string,
        default: "part_2_input.txt"
      ],
      example_input: [
        type: :string,
        default: "example_input.txt"
      ],
      part_2_example_input: [
        type: :string,
        default: "part_2_example_input.txt"
      ],
      handle_input: [
        type:
          {:spark_function_behaviour, Aoc.Day.InputHandler, {Aoc.Day.InputHandler.Function, 1}}
      ],
      handle_part_2_input: [
        type:
          {:spark_function_behaviour, Aoc.Day.InputHandler, {Aoc.Day.InputHandler.Function, 1}}
      ]
    ]
  }

  @solutions %Spark.Dsl.Section{
    name: :solutions,
    schema: [
      part_1: [
        type: {:spark_function_behaviour, Aoc.Day.Solver, {Aoc.Day.Solver.Function, 1}},
        required: true
      ],
      part_2: [
        type: {:spark_function_behaviour, Aoc.Day.Solver, {Aoc.Day.Solver.Function, 1}}
      ]
    ],
    imports: [
      Aoc.Helpers
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
      ],
      part_1_visual?: [
        type: :boolean,
        default: false
      ],
      part_2_visual?: [
        type: :boolean,
        default: false
      ]
    ]
  }

  @sections [@input, @solutions, @answers]

  use Spark.Dsl.Extension,
    sections: @sections,
    transformers: []
end
