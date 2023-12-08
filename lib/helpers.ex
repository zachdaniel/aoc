defmodule Aoc.Helpers do
  def lcm(values) do
    Enum.reduce(values, &least_common_multiple/2)
  end

  defp least_common_multiple(0, 0), do: 0

  defp least_common_multiple(left, right) do
    div(left * right, greatest_common_denominator(left, right))
  end

  def greatest_common_denominator(left, 0), do: left
  def greatest_common_denominator(0, right), do: right

  def greatest_common_denominator(left, right),
    do: greatest_common_denominator(right, rem(left, right))
end
