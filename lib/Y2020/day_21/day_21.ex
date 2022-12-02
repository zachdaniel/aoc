defmodule Aoc.Y2020.Day21 do
  use Aoc.Day

  answers do
    part_1 2569
    part_2 "vmhqr,qxfzc,khpdjv,gnrpml,xrmxxvn,rfmvh,rdfr,jxh"
  end

  input do
    handle_input fn input ->
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        case String.split(line, "(contains ") do
          [ingredients] ->
            {String.trim(ingredients), ""}

          [ingredients, allergens] ->
            {String.trim(ingredients), String.trim_trailing(allergens, ")")}
        end
      end)
      |> Enum.map(fn {ingredients, allergens} ->
        %{
          ingredients: String.split(ingredients, " "),
          allergens: String.split(allergens, ", ")
        }
      end)
    end
  end

  solutions do
    part_1 fn input ->
      input
      |> all_ingredients()
      |> with_possible_allergens(input)
      |> Enum.filter(fn {_, allergens} -> allergens == [] end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(&count_appearance(&1, input))
      |> Enum.sum()
    end

    part_2 fn input ->
      input
      |> all_ingredients()
      |> with_possible_allergens(input)
      |> Enum.filter(fn {_, allergens} -> allergens != [] end)
      |> determine_exact_allergens()
      |> Enum.map(fn {ingredient, [allergen]} ->
        {ingredient, allergen}
      end)
      |> Enum.sort_by(&elem(&1, 1))
      |> Enum.map(&elem(&1, 0))
      |> Enum.join(",")
    end
  end

  defp determine_exact_allergens(all_allergens) do
    all_allergens
    |> Enum.map(fn
      {ingredient, allergens} = item ->
        allergens
        |> Enum.find(fn allergen ->
          all_allergens
          |> Enum.reject(&(&1 == item))
          |> Enum.all?(&(allergen not in elem(&1, 1)))
        end)
        |> case do
          nil ->
            item

          allergen ->
            {ingredient, [allergen]}
        end
    end)
    |> case do
      ^all_allergens -> all_allergens
      other -> determine_exact_allergens(other)
    end
  end

  defp all_ingredients(input) do
    input
    |> Enum.flat_map(& &1.ingredients)
    |> Enum.uniq()
  end

  defp with_possible_allergens(all_ingredients, input, old_possible_allergens \\ nil) do
    Enum.into(all_ingredients, %{}, fn ingredient ->
      possible_allergens =
        input
        |> Enum.filter(&(ingredient in &1.ingredients))
        |> Enum.flat_map(& &1.allergens)
        |> Enum.uniq()
        |> Enum.reject(fn allergen ->
          Enum.any?(input, fn %{ingredients: ingredients, allergens: allergens} ->
            ingredient not in ingredients and allergen in allergens
          end)
        end)

      {ingredient, possible_allergens}
    end)
    |> case do
      ^old_possible_allergens ->
        old_possible_allergens

      new_possible_allergens ->
        with_possible_allergens(all_ingredients, input, new_possible_allergens)
    end
  end

  defp count_appearance(ingredient, input) do
    input
    |> Enum.flat_map(& &1.ingredients)
    |> Enum.count(&(&1 == ingredient))
  end
end
