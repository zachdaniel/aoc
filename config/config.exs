import Config

config :spark, :formatter,
  remove_parens?: true,
  "Aoc.Day": [
    section_order: [
      :answers,
      :input,
      :solutions
    ]
  ]
