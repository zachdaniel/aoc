# Used by "mix format"
spark_locals_without_parens = [
  example_input: 1,
  handle_input: 1,
  handle_part_2_input: 1,
  part_1: 1,
  part_1_input: 1,
  part_2: 1,
  part_2_example_input: 1,
  part_2_input: 1,
  use_example?: 1
]

[
  locals_without_parens: spark_locals_without_parens,
  plugins: [Spark.Formatter],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
