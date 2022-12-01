defmodule Aoc.Day.InputHandler do
  @callback handle(String.t(), opts :: Keyword.t()) :: term()
end

defmodule Aoc.Day.InputHandler.Function do
  @behaviour Aoc.Day.InputHandler

  def handle(input, fun: {m, f, a}) do
    apply(m, f, [input | a])
  end

  def handle(input, fun: fun) do
    fun.(input)
  end
end
