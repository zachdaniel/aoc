defmodule Aoc.Day.Info do
  alias Spark.Dsl.Extension

  def part_1_answer(day) do
    Extension.fetch_opt(day, [:answers], :part_1)
  end

  def part_2_answer(day) do
    Extension.fetch_opt(day, [:answers], :part_2)
  end

  def part_1_answer_visual?(day) do
    Extension.fetch_opt(day, [:answers], :part_1_visual?)
  end

  def part_2_answer_visual?(day) do
    Extension.fetch_opt(day, [:answers], :part_2_visual?)
  end

  def use_example?(day) do
    Extension.get_opt(day, [:input], :use_example?, false)
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

  def part_2_input_handler(day) do
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
