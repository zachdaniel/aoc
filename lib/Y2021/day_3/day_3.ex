defmodule Aoc.Y2021.Day3 do
  use Aoc.Day

  answers do
    part_1 4_001_724
    part_2 587_895
  end

  input do
    handle_input fn input ->
      String.split(input, "\n")
    end
  end

  solutions do
    part_1 fn input ->
      number_of_inputs = Enum.count(input)

      number_of_ones_in_each_position =
        Enum.reduce(input, nil, fn binary, bits ->
          binary_digits =
            binary
            |> String.graphemes()
            |> Enum.map(&to_bit/1)

          if bits do
            Enum.zip_with(bits, binary_digits, &(&1 + &2))
          else
            binary_digits
          end
        end)

      {gamma, epsilon} = get_gamma_and_epsilon(number_of_ones_in_each_position, number_of_inputs)

      gamma * epsilon
    end

    part_2 fn input ->
      oxygen_rating = get_oxygen_rating(input)
      c02_rating = get_c02_rating(input)

      oxygen_rating * c02_rating
    end
  end

  defp get_oxygen_rating(input, index \\ 0)

  defp get_oxygen_rating([binary], _index), do: String.to_integer(binary, 2)

  defp get_oxygen_rating(inputs, index) do
    {number_of_ones, number_of_inputs} = count_ones_and_inputs(inputs, index)

    most_common_bit =
      if number_of_ones >= number_of_inputs / 2 do
        "1"
      else
        "0"
      end

    inputs
    |> Enum.filter(fn input ->
      String.at(input, index) == most_common_bit
    end)
    |> get_oxygen_rating(index + 1)
  end

  defp get_c02_rating(input, index \\ 0)

  defp get_c02_rating([binary], _index), do: String.to_integer(binary, 2)

  defp get_c02_rating(inputs, index) do
    {number_of_ones, number_of_inputs} = count_ones_and_inputs(inputs, index)

    least_common_bit =
      if number_of_ones >= number_of_inputs / 2 do
        "0"
      else
        "1"
      end

    inputs
    |> Enum.filter(fn input ->
      String.at(input, index) == least_common_bit
    end)
    |> get_c02_rating(index + 1)
  end

  defp count_ones_and_inputs(inputs, index) do
    Enum.reduce(inputs, {0, 0}, fn input, {number_of_ones, number_of_inputs} ->
      input
      |> String.at(index)
      |> to_bit()
      |> then(fn value -> {value + number_of_ones, number_of_inputs + 1} end)
    end)
  end

  defp get_gamma_and_epsilon(number_of_ones_in_each_position, total_items) do
    %{gamma: gamma, epsilon: epsilon} =
      Enum.reduce(
        number_of_ones_in_each_position,
        %{gamma: "", epsilon: ""},
        fn number_of_ones,
           %{
             gamma: gamma,
             epsilon: epsilon
           } ->
          if number_of_ones >= total_items / 2 do
            %{gamma: gamma <> "1", epsilon: epsilon <> "0"}
          else
            %{gamma: gamma <> "0", epsilon: epsilon <> "1"}
          end
        end
      )

    {String.to_integer(gamma, 2), String.to_integer(epsilon, 2)}
  end

  defp to_bit("1"), do: 1
  defp to_bit(_), do: 0
end
