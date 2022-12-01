defmodule Aoc.Day.Solver do
  @callback solve(String.t(), opts :: Keyword.t()) :: term()
end

defmodule Aoc.Day.Solver.Function do
  @behaviour Aoc.Day.Solver

  def solve(input, fun: {m, f, a}) do
    apply(m, f, [input | a])
  end

  def solve(input, fun: fun) do
    fun.(input)
  end
end
