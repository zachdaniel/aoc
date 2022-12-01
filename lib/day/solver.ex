defmodule Aoc.Day.Solver do
  @callback solver(String.t(), opts :: Keyword.t()) :: term()
end

defmodule Aoc.Day.Solver.Function do
  @behaviour Aoc.Day.Solver

  def solver(input, fun: fun) do
    fun.(input)
  end
end
